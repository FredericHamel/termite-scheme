
(load "common")

(define server (make-node "localhost" 3001))
(define client (make-node "localhost" 3002)) 

(node-init server)
(print "Press enter to exit... ")
(read-char)
