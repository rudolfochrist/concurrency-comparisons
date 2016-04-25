;;; barber-bt.lisp

(in-package :cl-user)
(defpackage #:barber-bt
  (:use :cl)
  (:export
   #:run))

(in-package :barber-bt)

(defvar *chairs* 3)
(defparameter *customers* 0)
(defvar *customer-lock* (bt:make-lock "chair-lock"))

(defparameter *open-business* t)

(defvar *sleeping-barber* (bt:make-condition-variable))
(defvar *sleeping-customer* (bt:make-condition-variable))

(defun get-haircut (customer)
  (loop while *open-business*
     do (bt:with-lock-held (*customer-lock*)
          (format t "~A enters shop.~%" customer)
          (cond
            ((zerop *customers*)
             (format t "~A wakes up barber.~%" customer)
             (incf *customers*)
             (bt:condition-notify *sleeping-barber*)
             (bt:condition-wait *sleeping-customer* *customer-lock*)
             (format t "~A got a haircut.~%" customer)
             (return-from get-haircut)) 
            ((< 0 *customers* *chairs*)
             (format t "~A takes a seat and waits.~%" customer)
             (incf *customers*)
             (bt:condition-wait *sleeping-customer* *customer-lock*)
             (format t "~A got a haircut.~%" customer)
             (return-from get-haircut))
            (t
             (format t "All seats are taken. ~A leaves shop~%" customer)
             (return-from get-haircut))))))

(defun cut-hair ()
  (loop while *open-business*
     do (bt:with-lock-held (*customer-lock*)
          (cond
            ((zerop *customers*)
             (format t "No customers here. Barber is going to sleep.~%")
             (bt:condition-wait *sleeping-barber* *customer-lock*))
            (t
             (format t "Barber is cutting hair~%")
             (decf *customers*)
             (sleep 1))))))

(defun run ()
  (let ((out *standard-output*))
    ;; create barber
    (bt:make-thread
     (lambda ()
       (let ((*standard-output* out))
         (cut-hair))))
    ;; create customers
    (loop for i from 1 to 50
       do (bt:make-thread
           (lambda ()
             (let ((*standard-output* out))
               (get-haircut (format nil "CUSTOMER-~D" i)))))))
  ;; open business for 10 sec.
  (sleep 10)
  (setf *open-business* nil)
  'ok)
