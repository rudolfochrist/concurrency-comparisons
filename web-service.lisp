;;; web-service.lisp

(in-package :cl-user)
(defpackage #:web-service
  (:use :cl :hunchentoot)
  (:export
   #:start-service
   #:stop-service))

(in-package :web-service)

(define-easy-handler (home :uri "/")
    ()
  (sleep 1)                             ; adding some delay
  (princ-to-string (random 10)))

(defparameter *acceptor* (make-instance 'easy-acceptor :port 4242))

(defun start-service (&key port disable-logging)
  (when port
    (setf *acceptor*
          (make-instance 'easy-acceptor :port port)))
  (when disable-logging
    (setf (acceptor-access-log-destination *acceptor*) nil
          (acceptor-message-log-destination *acceptor*) nil))
  (start *acceptor*))

(defun stop-service ()
  (when *acceptor*
    (stop *acceptor* :soft t)))
