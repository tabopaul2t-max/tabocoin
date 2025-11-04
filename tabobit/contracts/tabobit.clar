;; Tabobit SIP-010 Fungible Token

(use-trait sip10 .sip-010-trait.sip-010)
(impl-trait .sip-010-trait.sip-010)

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)

(define-constant TOKEN-NAME "Tabobit")
(define-constant TOKEN-SYMBOL "TBB")
(define-constant TOKEN-DECIMALS u8)

(define-map balances principal uint)
(define-data-var total-supply uint u0)
(define-data-var minter (optional principal) none)

(define-read-only (get-minter)
  (var-get minter))

(define-private (get-balance-of (who principal))
  (default-to u0 (map-get? balances who)))

(define-public (set-minter (new-minter principal))
  (begin
    (if (is-none (var-get minter))
        (var-set minter (some tx-sender))
        (asserts! (is-eq (unwrap! (var-get minter) (err ERR-NOT-AUTHORIZED)) tx-sender) (err ERR-NOT-AUTHORIZED)))
    (var-set minter (some new-minter))
    (ok true)))

(define-public (mint (amount uint) (recipient principal))
  (begin
    (let ((m (var-get minter)))
      (if (is-none m)
          (var-set minter (some tx-sender))
          (asserts! (is-eq (unwrap! m (err ERR-NOT-AUTHORIZED)) tx-sender) (err ERR-NOT-AUTHORIZED))))
    (map-set balances recipient (+ (get-balance-of recipient) amount))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok true)))

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (let ((sender-balance (get-balance-of sender)))
      (asserts! (>= sender-balance amount) (err ERR-INSUFFICIENT-BALANCE))
      (asserts! (is-eq tx-sender sender) (err ERR-NOT-AUTHORIZED))
      (map-set balances sender (- sender-balance amount))
      (map-set balances recipient (+ (get-balance-of recipient) amount))
      (ok true))))

;; SIP-010 required read-only functions
(define-read-only (get-name)
  (ok TOKEN-NAME))

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS))

(define-read-only (get-balance (who principal))
  (ok (get-balance-of who)))

(define-read-only (get-total-supply)
  (ok (some (var-get total-supply))))

(define-read-only (get-token-uri)
  (ok none))
