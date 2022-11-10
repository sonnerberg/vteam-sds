#!/usr/bin/env bash
rsync -av --progress */*.png sds_sammansatt/
/bin/cat 1_introduktion/introduktion.md 2_kundens_app/kundens_app_clean.md 3_kundens_webbgranssnitt/kundens_webbgranssnitt_clean.md 4_admin_granssnitt/admin.md 5_cykel_program/cyklar.md 6_databas/databas.md 7_REST_api/rest_api.md > sds_sammansatt/sds.md
