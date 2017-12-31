#lang racket/base

(provide serve)

(require web-server/servlet
         web-server/servlet-env
         (only-in file/sha1 bytes->hex-string)
         grommet/crypto/hmac

         "util.rkt"
         "transit.rkt"
         "config.rkt"
         "braid.rkt"
         "behaviour.rkt")

(define (handle-message msg)
  ;; TODO: run this in a thread or future?
  (act-on-message msg))

(define (start request)
  (let ([body (-> request request-post-data/raw)]
        [sig (some->> request request-headers (assoc 'x-braid-signature) cdr)])
    (if (and sig body
             (string=? sig
                       (bytes->hex-string (hmac-sha256 bot-token body))))
      (begin
        (handle-message (unpack body))
        (response/output void #:message #"OK"))
      (begin
        (println "Bad signature")
        (response/output void #:code 400 #:message #"Bad Request")))))

(define (serve port)
  (serve/servlet start
                 #:launch-browser? #f
                 #:quit? #f
                 #:listen-ip "127.0.0.1"
                 #:port port
                 #:servlet-regexp #rx""))
