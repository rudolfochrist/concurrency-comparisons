;;; sync.lisp

(in-package :cl-user)
(defpackage #:sync
  (:use :cl :drakma)
  (:export
   #:synchronous
   #:asynchronous
   #:using-plet))

(in-package :sync)

;;; make sure web-service is running with
;;; see web-service.lisp

(defun synchronous ()
  (write-line (http-request "http://localhost:4242/"))
  (write-line (http-request "http://localhost:4242/"))
  (write-line (http-request "http://localhost:4242/"))
  (values))

(setf lparallel:*kernel*
      (lparallel:make-kernel 2))

(defun asynchronous ()
  (let ((done (lparallel:make-channel)))
    (lparallel:submit-task done (lambda ()
                                  (write-line (http-request "http://localhost:4242/"))))
    (lparallel:submit-task done (lambda ()
                                  (write-line (http-request "http://localhost:4242/"))))
    (lparallel:submit-task done (lambda ()
                                  (write-line (http-request "http://localhost:4242/"))))
    (lparallel:receive-result done)
    (lparallel:receive-result done)
    (lparallel:receive-result done)
    (values)))

(defun using-plet ()
  (lparallel:plet ((one (http-request "http://localhost:4242/"))
                   (two (http-request "http://localhost:4242/"))
                   (three (http-request "http://localhost:4242/")))
    (write-line one)
    (write-line two)
    (write-line three)
    (values)))
