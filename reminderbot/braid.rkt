#lang racket/base

(provide send-message)

(require racket/port
         racket/string
         net/url
         net/base64

         "transit.rkt"
         "util.rkt"
         "config.rkt")

(define base-url (string->url braid-url))

(define (tee x) (println x) x)

(define (send-message msg)
  (let* ([url (combine-url/relative base-url "/bots/message")]
         [auth-header (-> (list bot-id ":" bot-token)
                          (string-join "")
                          string->bytes/utf-8
                          (base64-encode #"")
                          bytes->string/utf-8
                          (->> (string-append "Authorization: Basic ")))]
         [port (post-pure-port url (pack msg) (list auth-header))])
    (port->string port)))
