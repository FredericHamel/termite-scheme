
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

(node-init client)

(if (not
      (and (eq? max-length-set! #!unbound)
           (eq? max-depth-set! #!unbound)))
  (begin
    (max-length-set! 100)
    (max-depth-set! 5)))
(time (remote-set! server "x" my_lst))

(println "Press enter to continue...")
(read-char)

(remote-spawn
  server
  (test1 "x"))

(remote-spawn
  server
  (create-msg client "Salut"))


(println "Press any key to quit...")
(read-char)

