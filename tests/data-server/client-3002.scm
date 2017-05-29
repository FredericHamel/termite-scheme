
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

(define (clone lst)
  (map (lambda (x) (if (pair? x) (clone x) x)) lst))

(define lst (range 0 100))

(define my_lst (map (lambda (x) (clone lst)) lst))

(define big_lst (map (lambda (x) (clone my_lst)) my_lst))

(define (remote-exist server var)
  (if (on server (remote-lookup var))
    (println "Found " var)
    (println "No " var " found")))

(node-init client)

(remote-exist server "x")
(time (remote-set! server "x" my_lst))
(remote-exist server "x")

(println "Press enter to continue...")
(read-char)

(remote-spawn server (remote-print "x"))


(println "Press any key to quit...")
(read-char)

