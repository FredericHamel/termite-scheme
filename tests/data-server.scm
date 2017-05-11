(define node (make-node "localhost" 3001))

(define env '())

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
