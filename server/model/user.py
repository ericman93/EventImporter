from sqlalchemy import Column, Integer, String, func
from sqlalchemy.orm import relationship
from database import Base, db_session
from model.importers.events_importer import EventsImporter

class User(Base):
	__tablename__ = 'users'

	id = Column(Integer, primary_key=True, autoincrement=True)
	provider = Column(String)
	provider_id = Column(String)
	name = Column(String)
	events_importers = relationship("EventsImporter")

	def is_exsits(self):
		return db_session.query(func.count(User.provider_id)).filter_by(provider_id=self.provider_id, provider=self.provider).scalar() > 0
