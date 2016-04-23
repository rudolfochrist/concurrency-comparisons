;;; car-park.lisp

(in-package :cl-user)
(defpackage #:car-park-promises
  (:use :cl)
  (:export
   #:run))

(in-package :car-park-promises)

(defvar *max-parking-spaces* 25)

(defvar *car-park* '())


(defun run ()
  (setf *car-park* nil)
  'ok)
