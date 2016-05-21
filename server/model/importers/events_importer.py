from sqlalchemy import Column, Integer, String, func, ForeignKey
from sqlalchemy.orm import relationship
from database import Base, db_session
#from model.user import User

class EventsImporter(Base):
	__tablename__ = 'events_importer'

	id = Column(Integer, primary_key=True, autoincrement=True)
	type = Column(String)
	user_id = Column(Integer, ForeignKey('users.id'))
	user = relationship("User", back_populates="events_importers")