;;; car-park.lisp

(in-package :cl-user)
(defpackage #:car-park-bt
  (:use :cl)
  (:export
   #:run))

(in-package :car-park-bt)

(defvar *parking-space-available*
  (bt:make-condition-variable :name "parking-space-available"))

(defvar *car-park-lock*
  (bt:make-lock "car-park-lock"))

(defvar *max-parking-spaces* 25)

(defvar *car-park* '())

(defun enter-car-park (car)
  (format t "Car ~A wants to enter car park~%" car)
  (bt:with-lock-held (*car-park-lock*)
    (format t "Car Park: ~D cars~%" (length *car-park*))
    (loop while (>= (length *car-park*) *max-parking-spaces*)
       do (progn
            (format t "Car park full. Waiting for someone to leave~%")
            (bt:condition-wait *parking-space-available* *car-park-lock*)))
    (format t "Car ~A parks~%" car)
    (push car *car-park*)))

(defun leave-car-park (car)
  (format t "Car ~A is about to leave~%" car)
  (bt:with-lock-held (*car-park-lock*)
    (setf *car-park*
          (delete car *car-park*))
    (format t "Car ~A has left. ~D car space(s) are available.~%"
            car
            (- *max-parking-spaces* (length *car-park*)))
    (bt:condition-notify *parking-space-available*)))

(defun run ()
  (setf *car-park* nil)
  (let* ((output *standard-output*)
         (threads
          (loop repeat 50
             collect (bt:make-thread
                      (lambda ()
                        (let ((*standard-output* output)
                              (car (intern (format nil "car-~D" (random 999)))))
                          (enter-car-park car)
                          (sleep 5)     ; do some errands or stuff :]
                          (leave-car-park car)))))))
    (mapc #'bt:join-thread threads)
    'ok))
