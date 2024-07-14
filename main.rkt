#lang racket
(require compatibility/defmacro)

(define (files-read-all-bytes path)
  (call-with-input-file path
    (lambda (input-port)
      (define buffer (make-bytes 4096))
      (define result #"")
      (let loop ()
        (define bytes-read (read-bytes-avail! buffer input-port))
        (unless (eof-object? bytes-read)
          ;;(display (bytes->string/utf-8 buffer 0 bytes-read))
          (set! result (bytes-append result (subbytes buffer 0 bytes-read)))
          (loop)
          )
        )
      result
      )
    )
  )

(provide files-read-all-bytes)