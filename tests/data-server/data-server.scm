
(load "data-server-common")

(define node (make-node "localhost" 3001))

(define (data-server-loop)
  (let loop ()
    (recv
      ((from tag ('get sym))
       (let ((keyval (assoc sym env)))
         (println "get " sym)
         (if (pair? keyval)
           (! from (list tag (cdr keyval)))
           (! from (list tag 'no-such-variable)))))

      ((from tag ('set sym val))
       (let ((keyval (assoc sym env)))
         (begin
           (println "set " sym)
           (if (pair? keyval)
             (set-cdr! keyval val)
             (set! env (cons (cons sym val) env)))
           (! from (list tag #t)))))

      (('update-server k)
       (k #t))

      (msg
        (warning "Ignore msg: " msg)))
    (loop)))

(define data-server
  (spawn
    data-server-loop
    name: 'data-server))

(node-init node)
(publish-service 'data-server data-server)

(println "Press any key to print x...")
(read-char)

(define (find-promise env)
  (define (until pred env)
    (if (pred env)
      "<promise n>"
      (if (pair? env)
        (until pred (cdr env))
        'fail)))
  (if (pair? env)
    (let ((fst (car env))
          (tl (cdr env)))
      (let ((p (until ##promise? fst)))
        (if (eq? 'fail p)
          (find-promise tl)
          p)))))
         

;(println (find-promise env))

(println "Press any key to quit...")
(read-char)
