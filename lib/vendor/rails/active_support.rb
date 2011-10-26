module ActiveRecord
  # This patch all adds a #skip? method on the migration classes.  It is 
  # mainly intended to be used with feature toggles.
  #
  #    class FauxMigration < ActiveRecord::Migration
  #
  #      def skip?
  #        Feature.active?('178_feature_x')
  #      end
  #
  #      def up
  #        add_column :patients, :foob, :string
  #      end
  #
  #      def down
  #        remove_column :patients, :foob
  #      end
  #    end
  #
  class Migration

    def skip?
      false
    end

    def migrate_with_skip(direction)
      if skip?
        announce "Skipping Migration, skip? returned true."
      else
        migrate_without_skip(direction)
      end
    end
    alias_method :migrate_without_skip, :migrate
    alias_method :migrate, :migrate_with_skip
  end
 
  class MigrationProxy
    delegate :skip?, :to => :migration
  end

  class Migrator
    def record_version_state_after_migrating_with_skip(version)
      current = migrations.detect { |m| m.version == version } # This is actually the proxy for the migration
      unless current.skip?
        record_version_state_after_migrating_without_skip(version)
      end
    end

    alias_method :record_version_state_after_migrating_without_skip, :record_version_state_after_migrating
    alias_method :record_version_state_after_migrating, :record_version_state_after_migrating_with_skip
  end

end
