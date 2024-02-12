import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const updateAttendeesCount = functions.firestore
    .document('event/{eventId}/attendees/{attendeeId}')
    .onWrite(async (change, context) => {
        const eventId = context.params.eventId;
        const eventRef = admin.firestore().collection('event').doc(eventId);

        const attendeesSnapshot = await eventRef.collection('attendees').get();
        const attendeesCount = attendeesSnapshot.size;

        return eventRef.update({ attendees: attendeesCount });
    });
