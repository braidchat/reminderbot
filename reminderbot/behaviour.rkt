#lang racket/base

(provide act-on-message)

(require racket/match
         racket/string
         tasks

         "util.rkt"
         "braid.rkt")

(define (parse-seconds str)
  (some-> (regexp-match #rx"^.*([0-9]+) minutes$" str)
          cadr
          string->number
          (* 60)))

(define (act-on-message msg)
  (->> (if-let [secs (parse-seconds (hash-ref msg '#:content))]
        (begin
          (thread
           (λ ()
             (with-task-server
              (delayed-task
               secs
               (->> (list "This is your reminder you requested "
                         (number->string secs) "seconds ago")
                   (string-join)
                   (reply-to msg)))
              (run-tasks))))
          (-> (list "Okay, I'll remind you in" (number->string secs) "seconds")
              string-join))
        (-> (list "Sorry, I don't know what that means."
                  "Try something like `/reminderbot 5 minutes`.")
            (string-join "\n")))
      (reply-to msg)))
