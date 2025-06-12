;; Certification Issuance Contract
;; Issues and manages competency certifications

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_CERTIFICATION_NOT_FOUND (err u501))
(define-constant ERR_INSUFFICIENT_COMPETENCIES (err u502))
(define-constant ERR_CERTIFICATION_ALREADY_EXISTS (err u503))

;; Data structures
(define-map certifications
  { certification-id: uint }
  {
    student: principal,
    competency-ids: (list 20 (string-ascii 50)),
    issuer: principal,
    issue-date: uint,
    expiry-date: (optional uint),
    certification-type: (string-ascii 50),
    is-valid: bool,
    verification-hash: (buff 32)
  }
)

(define-map certification-templates
  { template-id: (string-ascii 50) }
  {
    name: (string-ascii 100),
    required-competencies: (list 20 (string-ascii 50)),
    minimum-scores: (list 20 uint),
    validity-period: (optional uint),
    issuing-authority: principal
  }
)

(define-map student-certifications
  { student: principal }
  {
    certification-ids: (list 50 uint),
    total-certifications: uint,
    active-certifications: uint
  }
)

(define-data-var certification-counter uint u0)

;; Public functions
(define-public (create-certification-template
  (template-id (string-ascii 50))
  (name (string-ascii 100))
  (required-competencies (list 20 (string-ascii 50)))
  (minimum-scores (list 20 uint))
  (validity-period (optional uint))
)
  (begin
    (map-set certification-templates
      { template-id: template-id }
      {
        name: name,
        required-competencies: required-competencies,
        minimum-scores: minimum-scores,
        validity-period: validity-period,
        issuing-authority: tx-sender
      }
    )
    (ok true)
  )
)

(define-public (issue-certification
  (student principal)
  (competency-ids (list 20 (string-ascii 50)))
  (certification-type (string-ascii 50))
  (validity-period (optional uint))
)
  (let (
    (certification-id (+ (var-get certification-counter) u1))
    (verification-hash (keccak256 (concat (unwrap-panic (to-consensus-buff? student))
                                         (unwrap-panic (to-consensus-buff? block-height)))))
    (expiry-date (match validity-period
      period (some (+ block-height period))
      none
    ))
  )
    ;; In practice, would verify student has mastered all required competencies
    (map-set certifications
      { certification-id: certification-id }
      {
        student: student,
        competency-ids: competency-ids,
        issuer: tx-sender,
        issue-date: block-height,
        expiry-date: expiry-date,
        certification-type: certification-type,
        is-valid: true,
        verification-hash: verification-hash
      }
    )

    ;; Update student certification record
    (match (map-get? student-certifications { student: student })
      existing-certs (map-set student-certifications
        { student: student }
        {
          certification-ids: (unwrap-panic (as-max-len?
            (append (get certification-ids existing-certs) certification-id) u50)),
          total-certifications: (+ (get total-certifications existing-certs) u1),
          active-certifications: (+ (get active-certifications existing-certs) u1)
        }
      )
      (map-set student-certifications
        { student: student }
        {
          certification-ids: (list certification-id),
          total-certifications: u1,
          active-certifications: u1
        }
      )
    )

    (var-set certification-counter certification-id)
    (ok certification-id)
  )
)

(define-public (revoke-certification (certification-id uint))
  (match (map-get? certifications { certification-id: certification-id })
    cert-data (begin
      (asserts! (is-eq tx-sender (get issuer cert-data)) ERR_UNAUTHORIZED)
      (map-set certifications
        { certification-id: certification-id }
        (merge cert-data { is-valid: false })
      )
      (ok true)
    )
    ERR_CERTIFICATION_NOT_FOUND
  )
)

;; Read-only functions
(define-read-only (get-certification (certification-id uint))
  (map-get? certifications { certification-id: certification-id })
)

(define-read-only (verify-certification (certification-id uint))
  (match (map-get? certifications { certification-id: certification-id })
    cert-data (and
      (get is-valid cert-data)
      (match (get expiry-date cert-data)
        expiry (< block-height expiry)
        true
      )
    )
    false
  )
)

(define-read-only (get-student-certifications (student principal))
  (map-get? student-certifications { student: student })
)

(define-read-only (get-certification-template (template-id (string-ascii 50)))
  (map-get? certification-templates { template-id: template-id })
)
