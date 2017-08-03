
(declare (block))

(define (make-message msg)
  (lambda ()
    (println msg)))
