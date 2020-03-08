FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends locales whois tzdata cups cups-client cups-bsd printer-driver-ptouch printer-driver-brlaser

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it.sh

RUN chmod +x /usr/local/bin/wait-for-it.sh \
 && echo "Europe/Berlin" > /etc/timezone \
 && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
 && sed -i "s/^#\ \+\(en_US.UTF-8\)/\1/" /etc/locale.gen \
 && locale-gen en_US.UTF-8 \
 && useradd --groups lp,lpadmin --create-home --password "$(mkpasswd print)" print

ENV LANG=en_US.UTF-8

COPY etc/cups/cupsd.conf /etc/cups/cupsd.conf
COPY add-printers.sh /usr/local/bin/

EXPOSE 631
VOLUME ["/etc/cups", "/var/log/cups"]
CMD ["/usr/sbin/cupsd", "-f"]
