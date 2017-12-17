#lang racket/base

(require web-server/servlet
         web-server/servlet-env

         "util.rkt"
         "transit.rkt")
(provide serve)

(define (start request)
  ;; TODO: validate signature
  (let ([message (-> request request-post-data/raw unpack)])
    (println message))
  (response/output void #:message #"OK"))

(define (serve port)
  (serve/servlet start
                 #:launch-browser? #f
                 #:quit? #f
                 #:listen-ip "127.0.0.1"
                 #:port port
                 #:servlet-regexp #rx""))
