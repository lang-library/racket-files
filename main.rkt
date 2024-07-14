#lang racket
(require compatibility/defmacro) ;; compatibility-lib
(require dyoo-while-loop) ;; while-loop

(define-macro (until cond . rest)
  `(while (not ,cond) ,@rest)
  )

#;(define (files-read-all-bytes path)
  (call-with-input-file path
    (lambda (input-port)
      (define buffer (make-bytes 4096))
      (define result #"")
      (let loop ()
        (define bytes-read (read-bytes-avail! buffer input-port))
        (unless (eof-object? bytes-read)
          (set! result (bytes-append result (subbytes buffer 0 bytes-read)))
          (loop)
          )
        )
      result
      )
    )
  )

(define (files-read-all-bytes path #:buffer-size [buffer-size 4096])
  (call-with-input-file path
    (lambda (input-port)
      (define buffer (make-bytes buffer-size))
      (define result #"")
      (define bytes-read #f)
      (until (eof-object? bytes-read)
        (unless (eof-object? bytes-read)
          (when bytes-read (set! result (bytes-append result (subbytes buffer 0 bytes-read))))
          )
        (set! bytes-read (read-bytes-avail! buffer input-port))
        )
      result
      )
    )
  )

(define (files-read-all-text-utf8 path #:buffer-size [buffer-size 4096])
  (define bytes (files-read-all-bytes path  #:buffer-size buffer-size))
  (bytes->string/utf-8 bytes)
  )

(provide files-read-all-bytes files-read-all-text-utf8)
