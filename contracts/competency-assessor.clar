;; Competency Assessor Verification Contract
;; Manages verification and authorization of competency assessors

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ASSESSOR_NOT_FOUND (err u101))
(define-constant ERR_ASSESSOR_ALREADY_EXISTS (err u102))
(define-constant ERR_ASSESSOR_NOT_ACTIVE (err u103))

;; Data structures
(define-map assessors
  { assessor: principal }
  {
    name: (string-ascii 50),
    specialization: (string-ascii 100),
    certification-level: uint,
    is-active: bool,
    verified-at: uint
  }
)

(define-map assessor-stats
  { assessor: principal }
  {
    total-assessments: uint,
    successful-assessments: uint,
    rating: uint
  }
)

;; Public functions
(define-public (register-assessor (name (string-ascii 50)) (specialization (string-ascii 100)) (certification-level uint))
  (let ((assessor tx-sender))
    (asserts! (is-none (map-get? assessors { assessor: assessor })) ERR_ASSESSOR_ALREADY_EXISTS)
    (map-set assessors
      { assessor: assessor }
      {
        name: name,
        specialization: specialization,
        certification-level: certification-level,
        is-active: true,
        verified-at: block-height
      }
    )
    (map-set assessor-stats
      { assessor: assessor }
      {
        total-assessments: u0,
        successful-assessments: u0,
        rating: u5
      }
    )
    (ok true)
  )
)

(define-public (verify-assessor (assessor principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? assessors { assessor: assessor })
      assessor-data (begin
        (map-set assessors
          { assessor: assessor }
          (merge assessor-data { is-active: true, verified-at: block-height })
        )
        (ok true)
      )
      ERR_ASSESSOR_NOT_FOUND
    )
  )
)

(define-public (deactivate-assessor (assessor principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? assessors { assessor: assessor })
      assessor-data (begin
        (map-set assessors
          { assessor: assessor }
          (merge assessor-data { is-active: false })
        )
        (ok true)
      )
      ERR_ASSESSOR_NOT_FOUND
    )
  )
)

;; Read-only functions
(define-read-only (get-assessor (assessor principal))
  (map-get? assessors { assessor: assessor })
)

(define-read-only (is-verified-assessor (assessor principal))
  (match (map-get? assessors { assessor: assessor })
    assessor-data (get is-active assessor-data)
    false
  )
)

(define-read-only (get-assessor-stats (assessor principal))
  (map-get? assessor-stats { assessor: assessor })
)
