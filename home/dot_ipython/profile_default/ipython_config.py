# resides at $HOME/.ipython/profile_default/ipython_config.py
from pathlib import Path
import logging

_logger = logging.getLogger(Path(__file__).stem)

_logger.info('disabling parso logging')
logging.getLogger('parso').setLevel(level=logging.WARNING)
