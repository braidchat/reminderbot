#lang racket/base

(provide unpack uuid)
(require racket/port
         racket/string
         racket/match
         (prefix-in msgpack: msgpack)
         "util.rkt")

;; TODO: make this pretty-print like other UUIDs
(struct uuid (hi64 lo64) #:prefab)

(define (->transit form)
  (match form
    [(hash-table (_ _) ...)
     (-> form
         (hash-map (λ (k v) (cons (->transit k) (->transit v))))
         make-immutable-hash)]
    [(regexp #rx"^~:(.*)$" (list _ kw)) (string->keyword kw)]
    [(vector "~#u" (vector hi64 lo64)) (uuid hi64 lo64)]
    [(vector thing ...) (map ->transit thing)]
    [_ form]))

(define (unpack bytes)
  (-> (call-with-input-bytes
       bytes
       (λ (in) (msgpack:unpack in)))
      ->transit))
