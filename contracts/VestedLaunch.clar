;; VestedLaunch: STX/stable fundraising with vesting, refunds, KYC-ready

;; Replace 'SPXXXX.token-contract' with the actual contract principal and name implementing SIP-010

;; Constants
(define-constant ERR_NOT_OWNER (err u100))
(define-constant ERR_SALE_NOT_ACTIVE (err u101))
(define-constant ERR_SALE_ENDED (err u102))
(define-constant ERR_AMOUNT_TOO_LOW (err u103))
(define-constant ERR_WHITELISTED_ONLY (err u104))
(define-constant ERR_SOFTCAP_NOT_REACHED (err u105))
(define-constant ERR_NO_CONTRIBUTION (err u106))
(define-constant ERR_ALREADY_CLAIMED (err u107))
(define-constant ERR_NOT_CLAIMABLE_YET (err u108))
(define-constant ERR_INVALID_TOKEN (err u109))

;; Owner
(define-data-var owner principal tx-sender)

;; Token contracts
(define-data-var token-to-raise principal tx-sender)
(define-data-var token-to-sell principal tx-sender)

;; Sale parameters
(define-data-var price-per-token uint u1)
(define-data-var soft-cap uint u0)
(define-data-var hard-cap uint u0)
(define-data-var sale-start uint u0)
(define-data-var sale-end uint u0)
(define-data-var cliff-end uint u0)
(define-data-var vesting-period uint u0)
(define-data-var raised-amount uint u0)

;; Maps
(define-map whitelist { user: principal } { allowed: bool })
(define-map contributions { buyer: principal } { contributed: uint, claimed: uint })

;; Checks
(define-private (is-owner (caller principal))
  (is-eq caller (var-get owner))
)

(define-private (sale-active (now uint))
  (and (>= now (var-get sale-start)) (< now (var-get sale-end)))
)

;; Sale setup
(define-public (initialize-sale
    (raise-token principal) (sell-token principal)
    (price uint) (softc uint) (hardc uint)
    (start uint) (end uint)
    (cliff uint) (vesting uint))
  (begin
    (asserts! (is-owner tx-sender) ERR_NOT_OWNER)
    (asserts! (< start end) ERR_INVALID_TOKEN)
    (asserts! (< end (+ cliff vesting)) ERR_INVALID_TOKEN)
    (var-set token-to-raise raise-token)
    (var-set token-to-sell sell-token)
    (var-set price-per-token price)
    (var-set soft-cap softc)
    (var-set hard-cap hardc)
    (var-set sale-start start)
    (var-set sale-end end)
    (var-set cliff-end cliff)
    (var-set vesting-period vesting)
    (var-set raised-amount u0)
    (ok true)
  )
)

;; Whitelist
(define-public (add-to-whitelist (user principal))
  (begin
    (asserts! (is-owner tx-sender) ERR_NOT_OWNER)
    (map-set whitelist { user: user } { allowed: true })
    (ok true)
  )
)

(define-public (remove-from-whitelist (user principal))
  (begin
    (asserts! (is-owner tx-sender) ERR_NOT_OWNER)
    (map-delete whitelist { user: user })
    (ok true)
  )
)

(define-read-only (is-whitelisted (user principal))
  (default-to false (get allowed (map-get? whitelist { user: user })))
)

;; Contribute
(define-public (contribute (token principal) (amount uint))
  (begin
    (asserts! (sale-active stacks-block-height) ERR_SALE_NOT_ACTIVE)
    (asserts! (is-whitelisted tx-sender) ERR_WHITELISTED_ONLY)
    (asserts! (> amount u0) ERR_AMOUNT_TOO_LOW)
    (asserts! (is-eq token (var-get token-to-raise)) ERR_INVALID_TOKEN)
    (let ((current (var-get raised-amount)))
      (asserts! (<= (+ current amount) (var-get hard-cap)) ERR_AMOUNT_TOO_LOW)
     
      (let ((prev (default-to { contributed: u0, claimed: u0 } (map-get? contributions { buyer: tx-sender }))))
        (map-set contributions { buyer: tx-sender }
          { contributed: (+ (get contributed prev) amount), claimed: (get claimed prev) }))
      (var-set raised-amount (+ current amount))
      (ok true)
    )
  )
)

(define-read-only (get-contribution (user principal))
  (let ((opt (map-get? contributions { buyer: user })))
    (if (is-some opt)
        (ok (unwrap-panic opt))
        (ok { contributed: u0, claimed: u0 })
    )
  )
)

(define-read-only (get-whitelist-status (user principal))
  (ok (is-whitelisted user))
)

;; Ownership
(define-public (set-owner (new-owner principal))
  (begin
    (asserts! (is-owner tx-sender) ERR_NOT_OWNER)
    (var-set owner new-owner)
    (ok true)
  )
)

;; Initial owner set
(begin 
  (var-set owner tx-sender)
)
