#lang racket/base

(require racket/contract/base
         web-server/servlet
         web-server/servlet-env)
(provide serve)

(define (start request)
  (println request)
  (response/output
   (lambda (op)
     (write-bytes #"i am reminderbot" op)
     (void))))

(define (serve port)
  (serve/servlet start
                 #:launch-browser? #f
                 #:quit? #f
                 #:listen-ip "127.0.0.1"
                 #:port port
                 #:servlet-regexp #rx""))
