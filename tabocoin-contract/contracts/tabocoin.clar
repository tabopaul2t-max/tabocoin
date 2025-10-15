;; title: Tabocoin
;; version: 1.0.0
;; summary: A SIP-010 compliant fungible token for Tabocoin
;; description: Tabocoin is a fungible token implementation with standard transfer, mint, and burn functionality

;; traits
(use-trait sip-010-trait .sip-010-trait.sip-010-trait)
(impl-trait .sip-010-trait.sip-010-trait)

;; token definitions
(define-fungible-token tabocoin)

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))

;; data vars
(define-data-var token-name (string-ascii 32) "Tabocoin")
(define-data-var token-symbol (string-ascii 10) "TABO")
(define-data-var token-uri (optional (string-utf8 256)) none)
(define-data-var token-decimals uint u6)

;; data maps

;; public functions

;; SIP-010 Standard Functions

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (ft-transfer? tabocoin amount sender recipient)
  )
)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (ft-mint? tabocoin amount recipient)
  )
)

(define-public (burn (amount uint) (owner principal))
  (begin
    (asserts! (or (is-eq tx-sender owner) (is-eq tx-sender contract-owner)) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (ft-burn? tabocoin amount owner)
  )
)

(define-public (set-token-uri (value (optional (string-utf8 256))))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (var-set token-uri value))
  )
)

;; read only functions

(define-read-only (get-name)
  (ok (var-get token-name))
)

(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

(define-read-only (get-decimals)
  (ok (var-get token-decimals))
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance tabocoin who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply tabocoin))
)

(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; private functions

;; Initialize contract with initial supply
(define-public (initialize (initial-supply uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? tabocoin initial-supply contract-owner)
  )
)

