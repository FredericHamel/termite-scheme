
(define (remote-list-fetch lst)
  (define (counter reste)
    (if (pair? lst)
      (let ((cd (cdr lst)))
        (if (proxy? cd)
          (begin
            (set-cdr! lst (remote-cdr cd))
            (counter (cdr lst)))
          (counter cd)))
      lst))
  (counter lst))

(define (remote-list-length lst)
  (define (counter c lst)
    (if (pair? lst)
      (let ((cd (cdr lst)))
        (if (proxy? cd)
          (begin
            (set-cdr! lst (remote-cdr cd))
            (counter (+ c 1) (cdr lst)))
          (counter (+ c 1) cd)))
      c))
  (counter 0 lst))
               
    

