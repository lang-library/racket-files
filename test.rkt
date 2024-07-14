#lang racket
(require "./main.rkt")
(require pprint-all)

(files-read-all-bytes "./xyz.dll.rkt")
(files-read-all-text-utf8 "./xyz.dll.rkt")

(files-read-all-bytes "./xyz.dll.rkt" #:buffer-size 5)
(files-read-all-text-utf8 "./xyz.dll.rkt" #:buffer-size 5)
