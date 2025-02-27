;; Chronon Capture Contract

(define-map chronon-captures
  { id: uint }
  {
    harvester: principal,
    amount: uint,
    timestamp: uint
  }
)

(define-data-var next-capture-id uint u0)
(define-data-var total-energy-harvested uint u0)

(define-public (capture-chronons (amount uint))
  (let
    ((capture-id (var-get next-capture-id)))
    (var-set next-capture-id (+ capture-id u1))
    (var-set total-energy-harvested (+ (var-get total-energy-harvested) amount))
    (ok (map-set chronon-captures
      { id: capture-id }
      {
        harvester: tx-sender,
        amount: amount,
        timestamp: block-height
      }
    ))
  )
)

(define-read-only (get-capture (capture-id uint))
  (map-get? chronon-captures { id: capture-id })
)

(define-read-only (get-total-energy-harvested)
  (var-get total-energy-harvested)
)

