#lang racket
#|
Token highlighter con futures

Matías Mendez
Fernanda Nava
Eduardo Galindo
21/05/2021

|#
(require racket/trace)
(require racket/match)
(require json)
(provide main)

;Función oara identificar los tokens en el string del archivo recibido
(define (token-identifier in-file-path)
  
  (let loop
    ;variables iniciales: convierte el archivo json recibido a string y crea una lista vacía
        ([string (file->string in-file-path)]
         [found-list empty])
    ;mientras el tamaño del string sea mayor a 0
    (if (> (string-length string) 0)
        ; usa un let, para usar la variable token, donde se guarda la lista con los elementos que encontró y el nombre de la calse
        (let ([token
            (cond
              ;se hacen los matches que permiten identificar los tokens
           [(regexp-match #px"^[{}:,\\[\\]]+" string)(list "punctuation" (car(regexp-match #px"^[{}:,\\[\\]]+" string)))]

           [(regexp-match #px"^(\"[-()a-zA-Z0-9=/:,.*_+;&@?'¨\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df ]+\"):" string)
            (list "object-key" (cadr(regexp-match #px"^(\"[-()a-zA-Z0-9=/:,.*_+;&@?'¨\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df ]+\"):" string)))]

           [(regexp-match #px"^(\"[-()a-zA-Z0-9=/:,.*_+;&@?'¨\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df ]+\")" string)
            (list "string" (car(regexp-match #px"^(\"[-()a-zA-Z0-9=/:,.*_+;&@?'¨\u00c4\u00e4\u00d6\u00f6\u00dc\u00fc\u00df ]+\")" string)))]

           [(regexp-match #px"^(\"\")" string)(list "punctuation" (car(regexp-match #px"^(\"\")" string)))]

           [(regexp-match #px"^[-0-9E+*.]" string)(list "int" (car(regexp-match #px"^[-0-9E+*.]" string)))]

           [(regexp-match #px"^\\s+" string)(list "space" (car(regexp-match #px"^\\s+" string)))]

           [(regexp-match #px"^(true|false|null)" string)(list "boolean" (car(regexp-match #px"^(true|false|null)" string)))]
           
           )])
          ;llama a la función de manera recursiva, usando como argumentos la lista con los tokens encontrados
          ;y la longitud del string después de restarle los elementos encontrados
           (loop (substring string (string-length (cadr token)))(append found-list (list token))))
           found-list
           )))
                 
(define (write-file out-file-path data)
  ;llama al documento donde se escribirá la respuesta
  (call-with-output-file out-file-path
    #:exists 'truncate
    (lambda (out)
      ;hace los displays necesarios para que sea en formato html
      (displayln "<!DOCTYPE html>" out)
      (displayln "<html>" out)
      (displayln "<head>" out)
      (displayln "<title>" out)
      (displayln "Json Codee" out)
      (displayln "</title>" out)
      (displayln "<link rel=\"stylesheet\" href=\"tokens.css\">" out)
      (displayln "</head>" out)
      (displayln "<body>" out)
      (displayln "<pre>" out)
      ; llama la función para cada lista dentro de la lista y accede a sus dos elementos para hacer el display
      (for ([i data])
        (display (string-append "<span class=\"" (car i) "\">" (cadr i) "</span>" )out))
      (displayln "</pre>" out)
      (displayln "</body>" out)
      (displayln "</html>" out))))


(define (split-file-extension input-string)
  ;" Extract only the name part of a file name "
  (let
    ;guarda los matches de la regular expresion para indetificar nombres de archivo en dos grupos
    ([matches (regexp-match #px"^([\\w-]+)(\\.\\w{1,4})" (path->string(file-name-from-path input-string)))])
    ;selecciona solo el primer grupo que contiene 
    (string-append (car matches)".html")
    )
  )

;función principal
(define (read-files in-file-path)
  (future (lambda ()
  ;llama a la función de dividir el nombre de archivo para aobtener el nombre del nuevo
  (define out-file-path (split-file-extension in-file-path))
  ;obtiene la lista de los tokens invocando a la función para identificar los tokens
  (define data (token-identifier in-file-path))
  ;se imprime el resultado obtenido
  (write-file out-file-path data))))


(define (main directory_name)
  (time
   ;crea una list con las ubicaciones de los archivos dentro de un directorio
  (define directories (map path->string (directory-list[build-path (current-directory) directory_name] #:build? #t)))
  ;crea un future para cada archivo dentro de el directorio y los lee
  (define futures (map read-files directories))
  ; Combina los resultados de los múltiples futures
  (define result (map touch futures))
  ;Imprime el resultado
  (printf "Result: ~a\n" result)
  (void)))
