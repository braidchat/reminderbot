#lang racket/base

(provide
 ->
 ->>
 some->>)

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

(define-syntax some->>
  (syntax-rules ()
    [(_ x (f a ...)) (if x (f a ... x) x)]
    [(_ x f) (if x (f x) x)]
    [(_ x f g ...) (if x (some->> (some->> x f) g ...) x)]))
