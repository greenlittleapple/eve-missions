server {
	listen 80;
	listen 443 ssl;
       server_name www.eve-missions.com
       index index.html;

	ssl on;
	ssl_certificate ssl/eve-missions.crt;
	ssl_certificate_key ssl/eve-missions.key;
	ssl_protocols TLSv1.2 TLSv1.1;
       root /var/www/eve-missions.com/www;

       access_log /var/log/nginx/eve-missions.com/access_log main;
       error_log /var/log/nginx/eve-missions.com/error_log info;


       location ~ [^/]\.php(/|$) {
               fastcgi_split_path_info ^(.+?\.php)(/.*)$; if (!-f
               $document_root$fastcgi_script_name) {
                       return 404;
               }

               fastcgi_pass unix:/var/run/php5-fpm.sock; fastcgi_index
               index.php; include fastcgi_params;
       }

       location / {
                try_files $uri $uri/ $uri.html $uri.php ;
       }
       location ~ \.php$ {
                try_files $uri =404;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.html;
                include fastcgi_params;
       }
}

server {
  listen 80;
  listen 443;
  server_name eve-missions.com;
  # add ssl settings
  return 301 https://www.eve-missions.com$request_uri;
}

server {
        listen 80;
        server_name php.eve-missions.com;

        index index.php;

        root /var/www/eve-missions.com/php;

        access_log /var/log/nginx/eve-missions.com/php.access_log main;
        error_log /var/log/nginx/eve-missions.com/php.error_log info;

        location ~ [^/]\.php(/|$) {
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                if (!-f $document_root$fastcgi_script_name) {
                        return 404;
                }

                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                include fastcgi_params;
        }
}

server {
        listen 80;
        server_name test.eve-missions.com;

        index index.html;

        root /var/www/eve-missions.com/dev;

        access_log /var/log/nginx/eve-missions.com/test.access_log main;
        error_log /var/log/nginx/eve-missions.com/test.error_log info;

        location ~ [^/]\.php(/|$) {
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                if (!-f $document_root$fastcgi_script_name) {
                        return 404;
                }

                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                include fastcgi_params;
        }
}

server {
        listen 80;
        server_name forums.eve-missions.com;

        index index.php;

        root /var/www/eve-missions.com/forums;

        access_log /var/log/nginx/eve-missions.com/test.access_log main;
        error_log /var/log/nginx/eve-missions.com/test.error_log info;

        location ~ [^/]\.php(/|$) {
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                if (!-f $document_root$fastcgi_script_name) {
                        return 404;
                }

                fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                include fastcgi_params;
        }
}

