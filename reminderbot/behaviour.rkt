#lang racket/base

(provide act-on-message)

(require racket/match

         "braid.rkt")

(define (act-on-message msg)
  (match msg
    [(hash-table (#:content "/reminderbot hi") (_ _) ...)
     (reply-to msg "Hi to you too!")]
    [_ (reply-to msg "Hi, I'm the reminder bot!")]))
