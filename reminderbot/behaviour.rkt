#lang racket/base

(provide act-on-message)

(require racket/match
         racket/string
         tasks

         "util.rkt"
         "braid.rkt")

(define reminder-re #rx"^/reminderbot (.*) in ([0-9]+) minutes$")

(define (parse-reminder str)
  (if-let [matches (regexp-match reminder-re str)]
    (let ([secs (-> matches caddr string->number (* 60))]
          [txt (cadr matches)])
      (list secs txt))
    #f))

(define (act-on-message msg)
  (->> (if-let [rem (parse-reminder (hash-ref msg '#:content))]
        (let ([secs (car rem)]
              [txt (cadr rem)])
          (thread
           (λ ()
             (with-task-server
              (delayed-task secs (reply-to msg txt))
              (run-tasks))))
          (-> (list "Okay, I'll remind you in" (number->string secs) "seconds")
              string-join))
        (-> (list "Sorry, I don't know what that means."
                  "Try something like "
                  "`/reminderbot check laundry in 5 minutes`.")
            (string-join "\n")))
      (reply-to msg)))
