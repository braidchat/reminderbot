#lang racket/base

(provide uuid uuid? uuid-hi64 uuid-lo64 make-uuid)

(require racket/random

         "util.rkt")

(struct uuid (hi64 lo64) #:prefab)

(define (bytes->number bs)
  (->> bs
      bytes->list
      (foldl (λ (b n) (+ b (arithmetic-shift n 8))) 0)))

(define (number->signed64 n)
  (- n (* 2 (bitwise-and n (arithmetic-shift 1 63)))))

(define (rand-64)
  (-> (crypto-random-bytes 8)
      bytes->number
      number->signed64))

(define (make-uuid)
  (uuid (rand-64) (rand-64)))
