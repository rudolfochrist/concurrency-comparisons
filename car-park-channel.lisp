;;; car-park-channel.lisp

(in-package :cl-user)
(defpackage #:car-park-channel
  (:use :cl :calispel)
  (:export
   #:run))

(in-package :car-park-channel)

(defun enter-car-park (car car-park)
  (format t "About to park car ~A!~%" car)
  (! car-park car)
  (format t "Car ~A parked!~%" car))

(defun leave-car-park (car-park)
  (loop
     (let ((car (? car-park)))
       (format t "Car ~A leaving.~%" car))))

(defun make-car-park-channel (&key capacity)
  (make-instance 'calispel:channel
                 :buffer (make-instance 'jpl-queues:bounded-fifo-queue
                                        :capacity capacity)))

(defun run ()
  (let* ((output *standard-output*)
         (car-park (make-car-park-channel :capacity 25))
         (entries (loop for i from 1 to 50
                     collect (bt:make-thread
                              (lambda () 
                                (let ((*standard-output* output))
                                  (enter-car-park (format nil "CAR-~D" i) car-park))))))
         (leaver (bt:make-thread
                  (lambda ()
                    (let ((*standard-output* output))
                      (leave-car-park car-park))))))
    (mapc #'bt:join-thread entries)
    (format t "Closing car park~%")
    (bt:destroy-thread leaver))
  'ok)
