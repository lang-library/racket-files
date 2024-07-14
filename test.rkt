#lang racket
(require "./main.rkt")
(require pprint-all)

(files-read-all-bytes "./xyz.dll.rkt")
(files-read-all-text-utf8 "./xyz.dll.rkt")
