#include "spawn_constants.hpp"

class TriggerDeletionOnceCleared {
    title = $STR_CID_DELETE_TRIGGER_ONCE_CLEARED;
    values[]= { DELETE_TRIGGER_ONCE_CLEARED_YES, DELETE_TRIGGER_ONCE_CLEARED_NO };
    texts[]={ $STR_CID_YES, $STR_CID_NO };
    default = DELETE_TRIGGER_ONCE_CLEARED_YES;
};