;; Camera Network Management Contract
;; Manages surveillance camera networks and their configurations

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_CAMERA_EXISTS (err u201))
(define-constant ERR_CAMERA_NOT_FOUND (err u202))
(define-constant ERR_INVALID_STATUS (err u203))

;; Camera status: 0 = offline, 1 = online, 2 = maintenance
(define-map cameras
  { camera-id: (string-ascii 50) }
  {
    owner: principal,
    location: (string-ascii 100),
    status: uint,
    installation-date: uint,
    last-maintenance: uint
  }
)

(define-map camera-permissions
  { camera-id: (string-ascii 50), accessor: principal }
  { permission-level: uint }
)

(define-data-var total-cameras uint u0)

;; Register a new camera
(define-public (register-camera
  (camera-id (string-ascii 50))
  (location (string-ascii 100)))
  (let ((owner tx-sender))
    (asserts! (is-none (map-get? cameras { camera-id: camera-id })) ERR_CAMERA_EXISTS)
    (map-set cameras
      { camera-id: camera-id }
      {
        owner: owner,
        location: location,
        status: u1,
        installation-date: block-height,
        last-maintenance: block-height
      }
    )
    (var-set total-cameras (+ (var-get total-cameras) u1))
    (ok camera-id)
  )
)

;; Update camera status
(define-public (update-camera-status (camera-id (string-ascii 50)) (new-status uint))
  (let ((camera-data (unwrap! (map-get? cameras { camera-id: camera-id }) ERR_CAMERA_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get owner camera-data)) ERR_UNAUTHORIZED)
    (asserts! (<= new-status u2) ERR_INVALID_STATUS)
    (ok (map-set cameras
      { camera-id: camera-id }
      (merge camera-data { status: new-status })
    ))
  )
)

;; Grant camera access permission
(define-public (grant-camera-access
  (camera-id (string-ascii 50))
  (accessor principal)
  (permission-level uint))
  (let ((camera-data (unwrap! (map-get? cameras { camera-id: camera-id }) ERR_CAMERA_NOT_FOUND)))
    (asserts! (is-eq tx-sender (get owner camera-data)) ERR_UNAUTHORIZED)
    (asserts! (<= permission-level u3) ERR_INVALID_STATUS)
    (ok (map-set camera-permissions
      { camera-id: camera-id, accessor: accessor }
      { permission-level: permission-level }
    ))
  )
)

;; Get camera information
(define-read-only (get-camera-info (camera-id (string-ascii 50)))
  (map-get? cameras { camera-id: camera-id })
)

;; Check camera access permission
(define-read-only (has-camera-access (camera-id (string-ascii 50)) (accessor principal))
  (is-some (map-get? camera-permissions { camera-id: camera-id, accessor: accessor }))
)

;; Get total number of cameras
(define-read-only (get-total-cameras)
  (var-get total-cameras)
)
