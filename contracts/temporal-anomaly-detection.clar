;; Temporal Anomaly Detection Contract

(define-map temporal-anomalies
  { id: uint }
  {
    detector: principal,
    location: (string-ascii 64),
    intensity: uint,
    detected-at: uint
  }
)

(define-data-var next-anomaly-id uint u0)

(define-public (report-anomaly (location (string-ascii 64)) (intensity uint))
  (let
    ((anomaly-id (var-get next-anomaly-id)))
    (var-set next-anomaly-id (+ anomaly-id u1))
    (ok (map-set temporal-anomalies
      { id: anomaly-id }
      {
        detector: tx-sender,
        location: location,
        intensity: intensity,
        detected-at: block-height
      }
    ))
  )
)

(define-read-only (get-anomaly (anomaly-id uint))
  (map-get? temporal-anomalies { id: anomaly-id })
)

(define-read-only (is-high-intensity-anomaly (anomaly-id uint))
  (match (map-get? temporal-anomalies { id: anomaly-id })
    anomaly (> (get intensity anomaly) u80)
    false
  )
)

