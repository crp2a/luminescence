FROM rocker/r2u:26.04

# Labels
LABEL org.opencontainers.image.authors="services-archeosciences@u-bordeaux-montaigne.fr" \
      org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.source="https://github.com/crp2a/luminescence" \
      org.opencontainers.image.vendor="UMR 6034 Archéosciences Bordeaux" \
      org.opencontainers.image.title="luminescence" \
      org.opencontainers.image.description="A collection of R shiny applications for luminescence dating."

# Configure shiny
RUN echo "\noptions(shiny.port=3838, shiny.host='0.0.0.0')" >> /etc/R/Rprofile.site

# Configure repositories
RUN echo "options(repos=c(getOption('repos'), crp2a='https://crp2a.r-universe.dev'))" >> /etc/R/Rprofile.site

# Install package
RUN R -q -e "options(warn=2); install.packages(c('RLumShiny','gammaShiny','Al2O3AnalysisApp'))"

# Run app
EXPOSE 3838

# Create user
RUN groupadd -g 2000 shiny && useradd -c 'shiny' -u 2000 -g 2000 -m -d /home/shiny -s /sbin/nologin shiny
USER shiny

ENV R_SCRIPT_DEFAULT_PACKAGES=NULL
CMD ["R", "-q", "-e", "RLumShiny::app_RLum()"]

