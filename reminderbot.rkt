#lang braidbot/insta

(require racket/match
         racket/string
         tasks

         braidbot/util
         braidbot/uuid)

(define bot-id "5a47c63e-8d23-4bba-92ef-53c3c0f7e398")
(define bot-token "4S3EzYM-exfyBibpYxEggiX7ahcWrRh3AIKoKbms")
(define braid-url "http://localhost:5557")

(listen-port 8899)

(define reminder-re #rx"^/reminderbot (.*) in ([0-9]+) minutes?$")

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
              (delayed-task
               secs
               (-> (make-immutable-hash)
                   (hash-set '#:id (make-uuid))
                   (hash-set '#:thread-id (make-uuid))
                   (hash-set '#:group-id (hash-ref msg '#:group-id))
                   (hash-set '#:content txt)
                   (hash-set '#:mentioned-user-ids
                             (list (hash-ref msg '#:user-id)))
                   (hash-set '#:mentioned-tag-ids '())
                   (send-message #:bot-id bot-id #:bot-token bot-token
                                 #:braid-url braid-url)))
              (run-tasks))))
          (-> (list "Okay, I'll remind you in" (number->string secs) "seconds")
              string-join))
        (-> (list "Sorry, I don't know what that means."
                  "Try something like "
                  "`/reminderbot check laundry in 5 minutes`.")
            (string-join "\n")))
      (reply-to msg
                #:bot-id bot-id #:bot-token bot-token
                #:braid-url braid-url)))
