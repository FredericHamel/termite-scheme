
(load "data-server-common")

(define server (make-node "localhost" 3001))
(define client (make-node "localhost" 3002))
(define (id x) x)

(define (range start end)
  (let loop ((cur end) (lst '()))
    (if (< start cur)
      (let ((val (- cur 1)))
        (loop val (cons val lst)))
      lst)))

(define (random-list n #!optional (max-value 100))
  (let loop ((lst '()))
    (set! n (- n 1))
    (if (> n 0)
      (loop (cons (random-integer max-value) lst))
      lst)))

(define nb_element 1000)

(define lst (random-list nb_element))

(define my_lst (map (lambda (x) (random-list x)) lst))

(define my_sublst_len (map length my_lst))

(define big_lst (map (lambda (lst) (map (lambda (x) (random-list x)) lst)) my_lst))
(define big_sublst_len (map (lambda (x) (map length x)) big_lst))

(define (remote-exist server var)
  (if (on server (remote-lookup var))
    (println "Found " var)
    (println "No " var " found")))

(node-init client)

; (max-length-set! 1000)
; (max-depth-set! 200)
(define (test)
  (proxy-print-debugging-info)
  (remote-exist server "x")
  (proxy-print-debugging-info)
  (time (remote-set! server "x" big_lst))
  (proxy-print-debugging-info)
  (remote-exist server "x")
  (proxy-print-debugging-info)
  (println (time (on server (remote-apply length "x"))))
  (proxy-print-debugging-info))

(println "### NON LAZY TEST ###")
(set-lazy-transform! #f)
(test)

(newline)
(println "### LAZY TEST ###")
(set-lazy-transform! #t)
(test)


