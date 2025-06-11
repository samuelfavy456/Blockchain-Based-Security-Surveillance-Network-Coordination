;; Evidence Management Contract
;; Manages surveillance evidence and chain of custody

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_EVIDENCE_EXISTS (err u501))
(define-constant ERR_EVIDENCE_NOT_FOUND (err u502))
(define-constant ERR_INVALID_TYPE (err u503))

;; Evidence type: 1 = video, 2 = image, 3 = audio, 4 = document
;; Evidence status: 0 = collected, 1 = analyzed, 2 = archived, 3 = destroyed
(define-map evidence-records
  { evidence-id: (string-ascii 50) }
  {
    collector: principal,
    incident-id: (string-ascii 50),
    camera-id: (string-ascii 50),
    evidence-type: uint,
    status: uint,
    collection-time: uint,
    file-hash: (string-ascii 64),
    description: (string-ascii 500)
  }
)

(define-map chain-of-custody
  { evidence-id: (string-ascii 50), sequence: uint }
  {
    handler: principal,
    action: (string-ascii 100),
    timestamp: uint,
    notes: (string-ascii 300)
  }
)

(define-map evidence-access-log
  { evidence-id: (string-ascii 50), accessor: principal, access-time: uint }
  { purpose: (string-ascii 200) }
)

(define-data-var evidence-counter uint u0)

;; Collect evidence
(define-public (collect-evidence
  (evidence-id (string-ascii 50))
  (incident-id (string-ascii 50))
  (camera-id (string-ascii 50))
  (evidence-type uint)
  (file-hash (string-ascii 64))
  (description (string-ascii 500)))
  (begin
    (asserts! (is-none (map-get? evidence-records { evidence-id: evidence-id })) ERR_EVIDENCE_EXISTS)
    (asserts! (and (>= evidence-type u1) (<= evidence-type u4)) ERR_INVALID_TYPE)
    (map-set evidence-records
      { evidence-id: evidence-id }
      {
        collector: tx-sender,
        incident-id: incident-id,
        camera-id: camera-id,
        evidence-type: evidence-type,
        status: u0,
        collection-time: block-height,
        file-hash: file-hash,
        description: description
      }
    )
    ;; Record initial chain of custody entry
    (map-set chain-of-custody
      { evidence-id: evidence-id, sequence: u0 }
      {
        handler: tx-sender,
        action: "Evidence collected",
        timestamp: block-height,
        notes: "Initial collection"
      }
    )
    (var-set evidence-counter (+ (var-get evidence-counter) u1))
    (ok evidence-id)
  )
)

;; Update evidence status
(define-public (update-evidence-status
  (evidence-id (string-ascii 50))
  (new-status uint)
  (action (string-ascii 100))
  (notes (string-ascii 300)))
  (let ((evidence-data (unwrap! (map-get? evidence-records { evidence-id: evidence-id }) ERR_EVIDENCE_NOT_FOUND)))
    (asserts! (<= new-status u3) ERR_INVALID_TYPE)
    ;; Update evidence status
    (map-set evidence-records
      { evidence-id: evidence-id }
      (merge evidence-data { status: new-status })
    )
    ;; Add chain of custody entry
    (let ((next-sequence (+ (get-custody-sequence-count evidence-id) u1)))
      (map-set chain-of-custody
        { evidence-id: evidence-id, sequence: next-sequence }
        {
          handler: tx-sender,
          action: action,
          timestamp: block-height,
          notes: notes
        }
      )
    )
    (ok new-status)
  )
)

;; Log evidence access
(define-public (log-evidence-access
  (evidence-id (string-ascii 50))
  (purpose (string-ascii 200)))
  (begin
    (asserts! (is-some (map-get? evidence-records { evidence-id: evidence-id })) ERR_EVIDENCE_NOT_FOUND)
    (ok (map-set evidence-access-log
      { evidence-id: evidence-id, accessor: tx-sender, access-time: block-height }
      { purpose: purpose }
    ))
  )
)

;; Get evidence record
(define-read-only (get-evidence (evidence-id (string-ascii 50)))
  (map-get? evidence-records { evidence-id: evidence-id })
)

;; Get chain of custody entry
(define-read-only (get-custody-entry (evidence-id (string-ascii 50)) (sequence uint))
  (map-get? chain-of-custody { evidence-id: evidence-id, sequence: sequence })
)

;; Helper function to get custody sequence count (simplified)
(define-read-only (get-custody-sequence-count (evidence-id (string-ascii 50)))
  u0 ;; Simplified - in real implementation would count existing entries
)

;; Get total evidence count
(define-read-only (get-total-evidence)
  (var-get evidence-counter)
)
