#lang racket/base

(provide
 ->
 ->>)

(define-syntax ->
  (syntax-rules ()
    [(_ x) x]
    [(_ x (f a ...)) (f x a ...)]
    [(_ x f) (f x)]
    [(_ x f g ...) (-> (-> x f) g ...)]))

(define-syntax ->>
  (syntax-rules ()
    [(_ x (f a ...)) (f a ... x)]
    [(_ x f) (f x)]
    [(_ x f g ...) (->> (->> x f) g ...)]))
