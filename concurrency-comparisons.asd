;;; concurrency-comparisons.asd

(in-package :asdf-user)

(defsystem #:concurrency-comparisons
  :version "0.1.0"
  :description "Concurrency Libraries compared"
  :author "Sebastian Christ <rudolfo.christ@gmail.com>"
  :mailto "rudolfo.christ@gmail.com"
  :source-control (:git "https://github.com/rudolfochrist/concurrency-comparisons.git")
  :bug-tracker "https://github.com/rudolfochrist/concurrency-comparisons/issues"
  :license "LLGPL"
  :serial t
  :components ((:static-file "README.org")
               (:file "barber-bt")
               (:file "car-park-bt")
               (:file "sync")
               (:file "web-service"))
  :depends-on (:bordeaux-threads
               :lparallel
               :calispel
               :hunchentoot
               :drakma))
