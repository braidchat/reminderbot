#lang info
(define collection 'multi)
(define deps '("base"
               "rackunit-lib"
               "msgpack"))
(define build-deps '("scribble-lib" "racket-doc"))
(define scribblings '(("scribblings/reminderbot.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(james))
