#lang info
(define collection 'multi)
(define deps '("base"
               "braidbot"
               "tasks"))
(define build-deps '("web-server-lib"
                     "scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/reminderbot.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(james))
