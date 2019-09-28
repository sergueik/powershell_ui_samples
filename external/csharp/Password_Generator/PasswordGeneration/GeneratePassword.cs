using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Reflection;
using System.Security.Cryptography;
using System.Security.Permissions;
using System.Text;
using System.Windows.Forms;

//using CC = PasswordGeneration.Consecutives;
using GG = PasswordGeneration.GenerateGlobals;

namespace PasswordGeneration {

    public partial class GeneratePassword : Form {

        private readonly static Random random = new Random ( );
        const string  DIGITS = "0123456789";
        const string  LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
        const string  SPECIAL = @"!@#$%^&*()+=~[:'<>?,.|";
        const string  UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        const int     MINIMUM_PASSWORD_CHARACTERS = 6;        

        const int     TOOLTIP_AUTOPOP_DELAY = 5000;
        const int     TOOLTIP_INITIAL_DELAY = 100;
        const int     TOOLTIP_RESHOW_DELAY = 100;

        enum Types {
            NOT_SPECIFIED,
            SYMBOL,
            DIGIT,
            UPPERCASE,
            LOWERCASE,
            NUMBER_TYPES
            }

        bool            all_characters = true;
        bool            easy_to_read = false;
        bool            easy_to_say = false;
        Form            generate_help_form = null;
        bool            lower_case = true;
        int             desired_length = MINIMUM_PASSWORD_CHARACTERS;
        bool            numbers = true;
        bool            symbols = true;
        ToolTip         tooltip = new ToolTip ( );
        bool            upper_case = true;


        public GeneratePassword ( ) {
            InitializeComponent ( );
        }

        //  this event-handler is executed whenever an object with a
        //  tool tip is entered. its purpose is to fix a bug that 
        //  keeps a tool tip from being displayed once that its 
        //  display time out has been reached. it is my belief that 
        //  the bug is caused by a reentrancy error in the tool tip 
        //  timer code.

        void tooltip_reinitializer ( Object sender, EventArgs e ) {
            tooltip.Active = false;
            tooltip.Active = true;
            }

        bool initialize_tooltips( ) {
            tooltip.InitialDelay = TOOLTIP_INITIAL_DELAY;
            tooltip.ReshowDelay = TOOLTIP_RESHOW_DELAY;
            tooltip.AutoPopDelay = TOOLTIP_AUTOPOP_DELAY;
            tooltip.ShowAlways = true;

            tooltip.SetToolTip( generated_password_TB, "Contains the generated password" );
            generated_password_TB.MouseEnter += new EventHandler ( tooltip_reinitializer );
            tooltip.SetToolTip( password_strength_PB, String.Format (
                    "Provides an indication of the strength{0}" +
                    "of the generated password",
                    Environment.NewLine ) );
            password_strength_PB.MouseEnter += new EventHandler ( tooltip_reinitializer );

            tooltip.SetToolTip( password_length_NUD, "Enter the desired length of the password" );
            password_length_NUD.MouseEnter += new EventHandler ( tooltip_reinitializer );

            tooltip.SetToolTip( upper_case_letters_CHKBX,
                String.Format(
                    "Check to include uppercase letters{0}" +
                    "in the password",
                    Environment.NewLine ) );
            upper_case_letters_CHKBX.MouseEnter += new EventHandler ( tooltip_reinitializer );

            tooltip.SetToolTip( symbols_CHKBX,
                String.Format (
                    "Check to include symbols{0}" +
                    "in the password",
                    Environment.NewLine ) );
            symbols_CHKBX.MouseEnter +=
                new EventHandler ( tooltip_reinitializer );

            tooltip.SetToolTip( numbers_CHKBX, String.Format( "Check to include numbers{0}in the password", Environment.NewLine ) );
            numbers_CHKBX.MouseEnter += new EventHandler( tooltip_reinitializer );

            tooltip.SetToolTip( lower_case_letters_CHKBX, String.Format("Check to include lowercase letters{0}in the password", Environment.NewLine ) );
            lower_case_letters_CHKBX.MouseEnter += new EventHandler( tooltip_reinitializer );

            tooltip.SetToolTip( all_characters_RB, String.Format("Use any character combination{0}in the password", Environment.NewLine ) );
            all_characters_RB.MouseEnter += new EventHandler( tooltip_reinitializer );

            tooltip.SetToolTip( easy_to_read_RB, String.Format( "Avoid ambiguous characters like O, 0, I, 1{0} in the password", Environment.NewLine ) );
            easy_to_read_RB.MouseEnter += new EventHandler( tooltip_reinitializer );

            tooltip.SetToolTip( easy_to_say_RB, String.Format( "Avoid numbers and special characters{0}in the password", Environment.NewLine ) );
            easy_to_say_RB.MouseEnter += new EventHandler( tooltip_reinitializer );

            tooltip.SetToolTip( regenerate_BUT, "Click to regenerate the password" );
            regenerate_BUT.MouseEnter += new EventHandler( tooltip_reinitializer );

            tooltip.SetToolTip ( 
                generate_help_BUT,
                "Click to obtain help" );
            generate_help_BUT.MouseEnter +=
                new EventHandler ( tooltip_reinitializer );

            tooltip.SetToolTip ( 
                accept_password_BUT,
                String.Format (
                    "Click to return to the earlier page having{0}" +
                    "changed your password",
                    Environment.NewLine ) );
            accept_password_BUT.MouseEnter +=
                new EventHandler ( tooltip_reinitializer );

            tooltip.SetToolTip ( 
                cancel_generate_BUT,
                String.Format (
                    "Click to return to the earlier page without{0}" +
                    "having changed your password",
                    Environment.NewLine ) );
            cancel_generate_BUT.MouseEnter +=
                new EventHandler ( tooltip_reinitializer );

            return ( true );

            } // initialize_tooltips

        // ********************************** initialize_form_controls

        void initialize_form_controls ( )
            {

            this.Text = String.Format ( "Generate Password" );
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Icon = Properties.Resources.generate_icon;

            generated_password_TB.Clear ( );
            password_strength_PB.Value = 0;
            password_length_NUD.Value = MINIMUM_PASSWORD_CHARACTERS;
            upper_case_letters_CHKBX.Checked = true;
            symbols_CHKBX.Checked = true;
            numbers_CHKBX.Checked = true;
            lower_case_letters_CHKBX.Checked = true;
            all_characters_RB.Checked = true;
            easy_to_read_RB.Checked = false;
            easy_to_say_RB.Checked = false;

            } // initialize_form_controls

        public bool initialize_form ( ) {
            initialize_tooltips ( );
            initialize_form_controls ( );
            this.ActiveControl = regenerate_BUT;
            return ( true );

            }
        
        List<string> create_character_sets( bool all_characters, bool easy_to_read, bool easy_to_say, bool lower_case, bool numbers, bool symbols, bool  upper_case ) {
            string       digits = String.Empty;
            List<string> list = new List<string>( );
            string       lowercase = String.Empty;
            string       special = String.Empty;
            string       uppercase = String.Empty;
            
            if ( numbers ) {
                digits = DIGITS;
            }

            if ( lower_case ) {
                lowercase = LOWERCASE;
            }

            if ( symbols ) {
                special = SPECIAL;
            }

            if ( upper_case ) {
                uppercase = UPPERCASE;
            }
                                        
            if ( easy_to_say ) {
                digits = String.Empty;
                special = String.Empty;
            }
            else if ( easy_to_read ){
                                        
                if ( !String.IsNullOrEmpty( digits ) ){
                    digits = digits.Replace( "0", String.Empty ).Replace( "1", String.Empty );
                }

                if ( !String.IsNullOrEmpty( uppercase ) ) {
                    uppercase = uppercase.Replace( "O", String.Empty ).Replace( "I", String.Empty );
                }

                if ( !String.IsNullOrEmpty( lowercase ) ){
                    lowercase = lowercase.Replace( "o", String.Empty ).Replace( "l", String.Empty ).Replace( "i", String.Empty );
                }
                    
                if ( !String.IsNullOrEmpty( special ) ){
                    special = special.Replace( "!", String.Empty ).Replace( "|", String.Empty );
                    }
                }
            list.Clear( );
            // if a character class' copy 
            // has a non-zero length, add 
            // it to the List
            if ( uppercase.Length > 0 ){
                list.Add( uppercase );
            }

            if ( lowercase.Length > 0 ) {
                list.Add( lowercase );
            }

            if ( digits.Length > 0 ){
                list.Add( digits );
            }

            if ( special.Length > 0 ){
                list.Add( special );
            }
            return( list );
            }

        
        string strength_in_words( int  strength ) {
            string words = String.Empty;
            if ( strength > 100 ){
                strength = 100;
            }
            else if ( strength < 0 ){
                strength = 0;
            }

            if ( strength >= 80 ){
                words = "Very Strong";
            } else if ( strength >= 60 ){
                words = "Strong";
            } else if ( strength >= 40 ){
                words = "Good";
            } else if ( strength >= 20 ){
                words = "Weak";
            } else {
                words = "Very Weak";
            }

            return ( words );            
            }
        
            string generate_password( List<string> character_sets, int desired_length ){
            byte[ ]      bytes;
            string        characters;
            int           index = -1;
            StringBuilder sb = new StringBuilder ( );
            bytes = new byte[ desired_length ];
            new RNGCryptoServiceProvider( ).GetBytes ( bytes );

            foreach ( byte b in bytes ) {
                // randomly select a character class for each byte
                index = random.Next( character_sets.Count );
                characters = character_sets[ index ];
                // use mod to project byte b into the correct range
                sb.Append( characters[ b % characters.Length ] );
            }     
            return( sb.ToString ( ) );
            }

            void regenerate_password( ) {
            List<string> character_sets = new List<string>( );
            string          generated_password = String.Empty;
            int             strength = 0;
            
            character_sets = create_character_sets( all_characters, easy_to_read, easy_to_say, lower_case, numbers, symbols, upper_case );

            generated_password = generate_password( character_sets, desired_length );

            strength = password_strength( generated_password );
            
            password_strength_PB.Value = strength;
            strength_LAB.Text = strength_in_words( strength );

            GG.generated_password = generated_password;
            generated_password_TB.Clear( );
            generated_password_TB.Text = generated_password;
            }

        void display_help (  ) {
            generate_help_form = new GenerateHelp( );
            generate_help_form.Tag = "help";
            if ( ( ( GenerateHelp ) generate_help_form ).initialize_form( ) )  {
                generate_help_form.Show( );
                generate_help_form.Location = new Point( this.Location.X - generate_help_form.Size.Width - 10, this.Location.Y + ( this.Size.Height / 2 ) - ( generate_help_form.Size.Height / 2 ) );
            } else {
                MessageBox.Show( "Unable to open Help Window", "Fatal Error", MessageBoxButtons.OK, MessageBoxIcon.Error );
                Application.Exit ( );
            }
        }

        void BUT_Click( object sender, EventArgs e ) {
            Button button = ( Button ) sender;
            string name = button.Name.Trim ( );
            switch( name ) {
                case "cancel_generate_BUT":
                    GG.generated_password = String.Empty;
                    close_form( );
                    break;

                case "regenerate_BUT":
                    regenerate_password( );
                    break;

                case "accept_password_BUT":
                    //if ( !String.IsNullOrEmpty ( 
                    //                            generated_password ) )
                    //    {
                    //    GG.generated_password = generated_password;
                        close_form( );
                    //    }
                    //else 
                    //    {
                    //    MessageBox.Show ( 
                    //        String.Format (
                    //            "Password must exist before " +
                    //            "clicking{0}" +
                    //            "Accept Password",
                    //            Environment.NewLine ),
                    //        "Missing Password",
                    //        MessageBoxButtons.OK,
                    //        MessageBoxIcon.Warning );
                    //    }
                    break;

                case "generate_help_BUT":
                    display_help( );
                    break;

                default:
                    throw new ApplicationException( String.Format( "{0} is an unrecognized button", name ) ); 
                }
            }

        void NUD_ValueChanged( object sender, EventArgs e ) {
            NumericUpDown  nud = ( NumericUpDown ) sender;
            desired_length = Convert.ToInt32( nud.Value );
            regenerate_password( );
        }

        // ***************************************** RB_CheckedChanged

        void RB_CheckedChanged( object sender, EventArgs e ) {
            bool         is_checked = false;
            string       name = String.Empty;
            RadioButton  radio_button = ( RadioButton ) sender;

            is_checked = radio_button.Checked;
            name = radio_button.Name.Trim( );

            switch ( name )
                {
                case "all_characters_RB":
                    if ( is_checked )
                        {
                        all_characters = true;
                        easy_to_read = false;
                        easy_to_say = false;
                        }
                    break;

                case "easy_to_read_RB":
                    if ( is_checked )
                        {
                        all_characters = false;
                        easy_to_read = true;
                        easy_to_say = false;
                        }
                    break;

                case "easy_to_say_RB":
                    if ( is_checked )
                        {
                        all_characters = false;
                        easy_to_read = false;
                        easy_to_say = true;
                        }
                    break;

                default :
                    throw new ApplicationException (
                        String.Format (
                            "{0} is an unrecognized RadioButton name",
                            name ) );
                }
                
            regenerate_password ( );

            } // RB_CheckedChanged

        void CHKBX_CheckedChanged ( object sender, EventArgs e ) {
            CheckBox check_box = ( CheckBox ) sender;
            string name = check_box.Name.Trim ( );
            if ( !upper_case_letters_CHKBX.Checked && !lower_case_letters_CHKBX.Checked && !numbers_CHKBX.Checked && !symbols_CHKBX.Checked ) {
                check_box = upper_case_letters_CHKBX;
                name = check_box.Name.Trim( );
                upper_case = true;
                upper_case_letters_CHKBX.Checked = upper_case;
                MessageBox.Show( String.Format( "At least one CheckBox must be checked{0}Upper case letters has been checked", Environment.NewLine ), "CheckBox changed", MessageBoxButtons.OK, MessageBoxIcon.Warning );
            }
                
            switch( name ) {
                case "upper_case_letters_CHKBX":
                    upper_case = check_box.Checked;
                    break;

                case "symbols_CHKBX":
                    symbols = check_box.Checked;
                    break;


                case "numbers_CHKBX":
                    numbers = check_box.Checked;
                    break;


                case "lower_case_letters_CHKBX":
                    lower_case = check_box.Checked;
                    break;

                default :
                    throw new ApplicationException (
                        String.Format (
                            "{0} is an unrecognized CheckBox name",
                            name ) );
                }

            regenerate_password ( );

            } // CHKBX_CheckedChanged

        // ***************************************** password_strength

        /// <summary>
        /// Determines how strong a password is based on different 
        /// criteria; 0 is very weak and 100 is very strong
        /// 
        /// Concept from 
        /// 
        /// https://www.codeproject.com/script/Articles/
        ///     ViewDownloads.aspx?aid=59186 
        /// 
        /// which has been significantly modified 
        /// </summary>
        /// <param name="password">
        /// string containing the password whose strength is to be 
        /// determined
        /// </param>
        /// <returns>
        /// integer containing the strength of the password; in the 
        /// range  [ 0 - 100 ]
        /// </returns>
        int password_strength ( string password )
            {
            int [ ]    consecutives;
            Types      current_type = Types.NOT_SPECIFIED;
            int        digit_count = 0;
            int        lowercase_count = 0;
            int        password_length = password.Length;
            Types      prior_type = Types.NOT_SPECIFIED;
            Hashtable  repeated = new Hashtable();
            int        repeated_count = 0;
            int        requirments = 0;
            int        running_score = 0;
            int        sequential_alphabetic_count = 0;
            int        sequential_number_count = 0;
            int        symbol_count = 0;
            int        uppercase_count = 0;
            
            consecutives = new int [ ( int ) Types.NUMBER_TYPES ];
            for ( int i = ( int ) Types.NOT_SPECIFIED;
                    ( i < ( int ) Types.NUMBER_TYPES );
                      i++ )
                {
                consecutives [ i ] = 0;
                }
                                        // scan password
            foreach ( char current_character in password.
                                                    ToCharArray ( ) )
                {
                                        // count digits
                if ( Char.IsDigit ( current_character ) )
                    {
                    digit_count++;
                    current_type = Types.DIGIT;
                    }
                                        // count uppercase characters
                else if ( Char.IsUpper ( current_character ) )
                    {
                    uppercase_count++;
                    current_type = Types.UPPERCASE;
                    }
                                        // count lowercase characters
                else if ( Char.IsLower ( current_character ) )
                    {
                    lowercase_count++;
                    current_type = Types.LOWERCASE;
                    }
                                        // count symbols
                else if ( Char.IsSymbol ( current_character ) || 
                          Char.IsPunctuation ( current_character ) )
                    {
                    symbol_count++;
                    current_type = Types.SYMBOL;
                    }

                if ( current_type == prior_type )
                    {
                    consecutives [ ( int ) current_type ]++;
                    } 

                prior_type = current_type;
                    
                                        // count repeated letters 
                if ( Char.IsLetter ( current_character ) )
                    {
                    if ( repeated.Contains ( Char.ToLower ( 
                                             current_character ) ) ) 
                        {
                        repeated_count++;
                        }
                    else 
                        {
                        repeated.Add ( Char.ToLower ( 
                                            current_character ), 
                                       0 );
                        }
                    }

                }         
                                        // check for sequential alpha 
                                        // string patterns (forward 
                                        // and reverse) 
            for ( int i = 0; ( i < 23 ); i++ )
                {
                string  forward = LOWERCASE.Substring ( i, 3 );
                string  reverse = reverse_string ( forward );

                if ( ( password.ToLower ( ).
                                IndexOf ( forward ) != -1 ) || 
                     ( password.ToLower ( ).
                                IndexOf ( reverse ) != -1 ) )
                    {
                    sequential_alphabetic_count++;
                    }
                }
            for ( int i = 0; ( i < 8 ); i++)
                {
                string  forward = DIGITS.Substring ( i, 3 );
                string  reverse = reverse_string ( forward );

                if ( ( password.ToLower ( ).
                                IndexOf ( forward ) != -1 ) || 
                     ( password.ToLower ( ).
                                IndexOf ( reverse ) != -1 ) )
                    {
                    sequential_number_count++;
                    }
                }
                                        // ADDITIONS TO STRENGTH

            running_score = ( ( 4 * password_length ) +             
                              ( 2 * ( password_length - 
                                     uppercase_count ) ) +
                              ( 2 * ( password_length - 
                                     lowercase_count ) ) +
                              ( 4 * digit_count ) +
                              ( 6 * symbol_count ) );
                                        // requirments
            requirments = 0;

            if ( password_length >= 
                 MINIMUM_PASSWORD_CHARACTERS ) 
                {
                requirments++;
                }
            if ( uppercase_count > 0 ) 
                {
                requirments++;
                }
            if ( lowercase_count > 0 )
                {
                requirments++;
                }
            if ( digit_count > 0 )
                {
                requirments++;
                }
            if ( symbol_count > 0 ) 
                {
                requirments++;
                }

            if ( requirments > 3 )
                {
                running_score += ( 2 * requirments );
                }

                                        // DEDUCTIONS FROM STRENGTH

                                        // if only letters 
            if ( ( digit_count == 0 ) && ( symbol_count == 0 ) )
                {
                running_score -= password_length;
                }
                                        // if only digits 
            if ( digit_count == password_length )
                {
                running_score -= password_length;
                }
                                        // if repeated letters
            if ( repeated_count > 1 )
                {
                running_score -= ( repeated_count * 
                                   ( repeated_count - 1 ) );
                }

            for ( int i = 0; ( i < ( int ) Types.NUMBER_TYPES ); i++ )
                {
                running_score -= ( 2 * consecutives [ i ] );
                }
                
            running_score -= sequential_alphabetic_count;
            running_score -= sequential_number_count;
                                        // confine result to range
            if ( running_score > 100 )
                { 
                running_score = 100;
                } 
            else if ( running_score < 0 )
                { 
                running_score = 0;
                }

            return ( running_score );

            } // password_strength

        string reverse_string ( string s) {
            StringBuilder sb = new StringBuilder( );
            for ( int i = ( s.Length - 1 ); ( i >= 0 ); i-- ){
                sb.Append( s [ i ] );
            }
            return( sb.ToString( ) );
        }

        void detach_tooltip_event_handlers( ) {

            generated_password_TB.MouseEnter -= new EventHandler( tooltip_reinitializer );
            password_strength_PB.MouseEnter -= new EventHandler( tooltip_reinitializer );
            password_length_NUD.MouseEnter -= new EventHandler( tooltip_reinitializer );
            upper_case_letters_CHKBX.MouseEnter -= new EventHandler( tooltip_reinitializer );
            symbols_CHKBX.MouseEnter -= new EventHandler( tooltip_reinitializer );
            numbers_CHKBX.MouseEnter -= new EventHandler( tooltip_reinitializer );
            lower_case_letters_CHKBX.MouseEnter -= new EventHandler( tooltip_reinitializer );
            all_characters_RB.MouseEnter -= new EventHandler( tooltip_reinitializer );
            easy_to_read_RB.MouseEnter -= new EventHandler( tooltip_reinitializer );
            easy_to_say_RB.MouseEnter -= new EventHandler( tooltip_reinitializer );
            regenerate_BUT.MouseEnter -= new EventHandler( tooltip_reinitializer );
            generate_help_BUT.MouseEnter -= new EventHandler( tooltip_reinitializer );
            accept_password_BUT.MouseEnter -= new EventHandler( tooltip_reinitializer );
            cancel_generate_BUT.MouseEnter -= new EventHandler( tooltip_reinitializer );
        }
        
        void close_form( ) {
            detach_tooltip_event_handlers( );
            this.Close( );    
        }

        /// <summary>
        /// captures operating system messages
        /// </summary>
        /// <param name="message">
        /// the windows message to process
        /// </param>
        /// <include>
        /// System.Security.Permissions;
        /// </include>
        /// <seealso>
        /// https://docs.microsoft.com/en-us/dotnet/api/
        ///     system.windows.forms.control.wndproc?
        ///     view=netframework-3.5
        /// </seealso>/>
        const int WM_SYSCOMMAND = 0x0112;
        const int SC_CLOSE = 0xF060;

        [PermissionSet ( SecurityAction.Demand, Name = "FullTrust" ) ]
        protected override void WndProc( ref Message message ) {
            switch ( message.Msg ) {
				// WinForms X button click
                case WM_SYSCOMMAND:
                    if ( ( ( int ) message.WParam & 0xFFF0 ) == SC_CLOSE ){
                        close_form( );
                    }
                    break;
                }
            base.WndProc( ref message );
            }
        }
    }
