using System;
using System.Collections.Generic;
using System.Text;

namespace QiHe.Yaml.Grammar
{
    public partial class YamlParser
    {
        public YamlStream ParseYamlStream(ParserInput<char> input, out bool success)
        {
            this.SetInput(input);
            YamlStream yamlStream = ParseYamlStream(out success);
            if (this.Position < input.Length)
            {
                success = false;
                Error("Failed to parse remained input.");
            }
            return yamlStream;
        }

        private YamlStream ParseYamlStream(out bool success)
        {
            int errorCount = Errors.Count;
            YamlStream yamlStream = new YamlStream();
            int start_position = position;

            while (true)
            {
                ParseComment(out success);
                if (!success) { break; }
            }
            success = true;

            while (true)
            {
                int seq_start_position1 = position;
                YamlDocument yamlDocument = ParseImplicitDocument(out success);
                if (success) { yamlStream.Documents.Add(yamlDocument); }
                success = true;

                while (true)
                {
                    yamlDocument = ParseExplicitDocument(out success);
                    if (success) { yamlStream.Documents.Add(yamlDocument); }
                    else { break; }
                }
                success = true;
                break;
            }

            success = !Input.HasInput(position);
            if (!success)
            {
                Error("Failed to parse end of YamlStream.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return yamlStream;
        }

        private YamlDocument ParseImplicitDocument(out bool success)
        {
            int errorCount = Errors.Count;
            YamlDocument yamlDocument = new YamlDocument();
            int start_position = position;

            currentDocument = yamlDocument; currentIndent = -1;
            yamlDocument.Root = ParseIndentedBlockNode(out success);
            if (!success)
            {
                Error("Failed to parse Root of ImplicitDocument.");
                position = start_position;
                return yamlDocument;
            }

            ParseEndOfDocument(out success);
            success = true;

            return yamlDocument;
        }

        private YamlDocument ParseExplicitDocument(out bool success)
        {
            int errorCount = Errors.Count;
            YamlDocument yamlDocument = new YamlDocument();
            int start_position = position;

            currentDocument = yamlDocument; currentIndent = -1;
            while (true)
            {
                Directive directive = ParseDirective(out success);
                if (success) { yamlDocument.Directives.Add(directive); }
                else { break; }
            }
            success = true;

            MatchTerminalString("---", out success);
            if (!success)
            {
                Error("Failed to parse '---' of ExplicitDocument.");
                position = start_position;
                return yamlDocument;
            }

            yamlDocument.Root = ParseSeparatedBlockNode(out success);
            if (!success)
            {
                Error("Failed to parse Root of ExplicitDocument.");
                position = start_position;
                return yamlDocument;
            }

            ParseEndOfDocument(out success);
            success = true;

            return yamlDocument;
        }

        private void ParseEndOfDocument(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            MatchTerminalString("...", out success);
            if (!success)
            {
                Error("Failed to parse '...' of EndOfDocument.");
                position = start_position;
                return;
            }

            ParseInlineComments(out success);
            if (!success)
            {
                Error("Failed to parse InlineComments of EndOfDocument.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
        }

        private Directive ParseDirective(out bool success)
        {
            int errorCount = Errors.Count;
            Directive directive = null;

            directive = ParseYamlDirective(out success);
            if (success) { ClearError(errorCount); return directive; }

            directive = ParseTagDirective(out success);
            if (success) { ClearError(errorCount); return directive; }

            directive = ParseReservedDirective(out success);
            if (success) { ClearError(errorCount); return directive; }

            return directive;
        }

        private ReservedDirective ParseReservedDirective(out bool success)
        {
            int errorCount = Errors.Count;
            ReservedDirective reservedDirective = new ReservedDirective();
            int start_position = position;

            MatchTerminal('%', out success);
            if (!success)
            {
                Error("Failed to parse '%' of ReservedDirective.");
                position = start_position;
                return reservedDirective;
            }

            reservedDirective.Name = ParseDirectiveName(out success);
            if (!success)
            {
                Error("Failed to parse Name of ReservedDirective.");
                position = start_position;
                return reservedDirective;
            }

            while (true)
            {
                while (true)
                {
                    int seq_start_position1 = position;
                    ParseSeparationSpace(out success);
                    if (!success)
                    {
                        Error("Failed to parse SeparationSpace of ReservedDirective.");
                        break;
                    }

                    string str = ParseDirectiveParameter(out success);
                    if (success) { reservedDirective.Parameters.Add(str); }
                    else
                    {
                        Error("Failed to parse DirectiveParameter of ReservedDirective.");
                        position = seq_start_position1;
                    }
                    break;
                }
                if (!success) { break; }
            }
            success = true;

            ParseInlineComments(out success);
            if (!success)
            {
                Error("Failed to parse InlineComments of ReservedDirective.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return reservedDirective;
        }

        private string ParseDirectiveName(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            int counter = 0;
            while (true)
            {
                char ch = ParseNonSpaceChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse (NonSpaceChar)+ of DirectiveName."); }
            return text.ToString();
        }

        private string ParseDirectiveParameter(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            int counter = 0;
            while (true)
            {
                char ch = ParseNonSpaceChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse (NonSpaceChar)+ of DirectiveParameter."); }
            return text.ToString();
        }

        private YamlDirective ParseYamlDirective(out bool success)
        {
            int errorCount = Errors.Count;
            YamlDirective yamlDirective = new YamlDirective();
            int start_position = position;

            MatchTerminalString("YAML", out success);
            if (!success)
            {
                Error("Failed to parse 'YAML' of YamlDirective.");
                position = start_position;
                return yamlDirective;
            }

            ParseSeparationSpace(out success);
            if (!success)
            {
                Error("Failed to parse SeparationSpace of YamlDirective.");
                position = start_position;
                return yamlDirective;
            }

            yamlDirective.Version = ParseYamlVersion(out success);
            if (!success)
            {
                Error("Failed to parse Version of YamlDirective.");
                position = start_position;
                return yamlDirective;
            }

            ParseInlineComments(out success);
            if (!success)
            {
                Error("Failed to parse InlineComments of YamlDirective.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return yamlDirective;
        }

        private YamlVersion ParseYamlVersion(out bool success)
        {
            int errorCount = Errors.Count;
            YamlVersion yamlVersion = new YamlVersion();
            int start_position = position;

            yamlVersion.Major = ParseInteger(out success);
            if (!success)
            {
                Error("Failed to parse Major of YamlVersion.");
                position = start_position;
                return yamlVersion;
            }

            MatchTerminal('.', out success);
            if (!success)
            {
                Error("Failed to parse '.' of YamlVersion.");
                position = start_position;
                return yamlVersion;
            }

            yamlVersion.Minor = ParseInteger(out success);
            if (!success)
            {
                Error("Failed to parse Minor of YamlVersion.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return yamlVersion;
        }

        private TagDirective ParseTagDirective(out bool success)
        {
            int errorCount = Errors.Count;
            TagDirective tagDirective = new TagDirective();
            int start_position = position;

            MatchTerminalString("TAG", out success);
            if (!success)
            {
                Error("Failed to parse 'TAG' of TagDirective.");
                position = start_position;
                return tagDirective;
            }

            ParseSeparationSpace(out success);
            if (!success)
            {
                Error("Failed to parse SeparationSpace of TagDirective.");
                position = start_position;
                return tagDirective;
            }

            tagDirective.Handle = ParseTagHandle(out success);
            if (!success)
            {
                Error("Failed to parse Handle of TagDirective.");
                position = start_position;
                return tagDirective;
            }

            ParseSeparationSpace(out success);
            if (!success)
            {
                Error("Failed to parse SeparationSpace of TagDirective.");
                position = start_position;
                return tagDirective;
            }

            tagDirective.Prefix = ParseTagPrefix(out success);
            if (!success)
            {
                Error("Failed to parse Prefix of TagDirective.");
                position = start_position;
                return tagDirective;
            }

            ParseInlineComments(out success);
            if (!success)
            {
                Error("Failed to parse InlineComments of TagDirective.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return tagDirective;
        }

        private TagHandle ParseTagHandle(out bool success)
        {
            int errorCount = Errors.Count;
            TagHandle tagHandle = null;

            tagHandle = ParseNamedTagHandle(out success);
            if (success) { ClearError(errorCount); return tagHandle; }

            tagHandle = ParseSecondaryTagHandle(out success);
            if (success) { ClearError(errorCount); return tagHandle; }

            tagHandle = ParsePrimaryTagHandle(out success);
            if (success) { ClearError(errorCount); return tagHandle; }

            return tagHandle;
        }

        private PrimaryTagHandle ParsePrimaryTagHandle(out bool success)
        {
            int errorCount = Errors.Count;
            PrimaryTagHandle primaryTagHandle = new PrimaryTagHandle();

            MatchTerminal('!', out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse '!' of PrimaryTagHandle."); }
            return primaryTagHandle;
        }

        private SecondaryTagHandle ParseSecondaryTagHandle(out bool success)
        {
            int errorCount = Errors.Count;
            SecondaryTagHandle secondaryTagHandle = new SecondaryTagHandle();

            MatchTerminalString("!!", out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse '!!' of SecondaryTagHandle."); }
            return secondaryTagHandle;
        }

        private NamedTagHandle ParseNamedTagHandle(out bool success)
        {
            int errorCount = Errors.Count;
            NamedTagHandle namedTagHandle = new NamedTagHandle();
            int start_position = position;

            MatchTerminal('!', out success);
            if (!success)
            {
                Error("Failed to parse '!' of NamedTagHandle.");
                position = start_position;
                return namedTagHandle;
            }

            int counter = 0;
            while (true)
            {
                char ch = ParseWordChar(out success);
                if (success) { namedTagHandle.Name.Add(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse Name of NamedTagHandle.");
                position = start_position;
                return namedTagHandle;
            }

            MatchTerminal('!', out success);
            if (!success)
            {
                Error("Failed to parse '!' of NamedTagHandle.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return namedTagHandle;
        }

        private TagPrefix ParseTagPrefix(out bool success)
        {
            int errorCount = Errors.Count;
            TagPrefix tagPrefix = null;

            tagPrefix = ParseLocalTagPrefix(out success);
            if (success) { ClearError(errorCount); return tagPrefix; }

            tagPrefix = ParseGlobalTagPrefix(out success);
            if (success) { ClearError(errorCount); return tagPrefix; }

            return tagPrefix;
        }

        private LocalTagPrefix ParseLocalTagPrefix(out bool success)
        {
            int errorCount = Errors.Count;
            LocalTagPrefix localTagPrefix = new LocalTagPrefix();
            int start_position = position;

            MatchTerminal('!', out success);
            if (!success)
            {
                Error("Failed to parse '!' of LocalTagPrefix.");
                position = start_position;
                return localTagPrefix;
            }

            while (true)
            {
                char ch = ParseUriChar(out success);
                if (success) { localTagPrefix.Prefix.Add(ch); }
                else { break; }
            }
            success = true;

            return localTagPrefix;
        }

        private GlobalTagPrefix ParseGlobalTagPrefix(out bool success)
        {
            int errorCount = Errors.Count;
            GlobalTagPrefix globalTagPrefix = new GlobalTagPrefix();

            int counter = 0;
            while (true)
            {
                char ch = ParseUriChar(out success);
                if (success) { globalTagPrefix.Prefix.Add(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse Prefix of GlobalTagPrefix."); }
            return globalTagPrefix;
        }

        private DataItem ParseDataItem(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = new DataItem();
            int start_position = position;

            while (true)
            {
                int seq_start_position1 = position;
                dataItem.Property = ParseNodeProperty(out success);
                if (!success)
                {
                    Error("Failed to parse Property of DataItem.");
                    break;
                }

                ParseSeparationLines(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationLines of DataItem.");
                    position = seq_start_position1;
                }
                break;
            }
            success = true;

            ErrorStatck.Push(errorCount); errorCount = Errors.Count;
            while (true)
            {
                dataItem = ParseScalar(out success);
                if (success) { ClearError(errorCount); break; }

                dataItem = ParseSequence(out success);
                if (success) { ClearError(errorCount); break; }

                dataItem = ParseMapping(out success);
                if (success) { ClearError(errorCount); break; }

                break;
            }
            errorCount = ErrorStatck.Pop();
            if (!success)
            {
                Error("Failed to parse (Scalar / Sequence / Mapping) of DataItem.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private Scalar ParseScalar(out bool success)
        {
            int errorCount = Errors.Count;
            Scalar scalar = null;

            scalar = ParseFlowScalarInBlock(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar = ParseFlowScalarInFlow(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar = ParseBlockScalar(out success);
            if (success) { ClearError(errorCount); return scalar; }

            return scalar;
        }

        private Sequence ParseSequence(out bool success)
        {
            int errorCount = Errors.Count;
            Sequence sequence = null;

            sequence = ParseFlowSequence(out success);
            if (success) { ClearError(errorCount); return sequence; }

            sequence = ParseBlockSequence(out success);
            if (success) { ClearError(errorCount); return sequence; }

            return sequence;
        }

        private Mapping ParseMapping(out bool success)
        {
            int errorCount = Errors.Count;
            Mapping mapping = null;

            mapping = ParseFlowMapping(out success);
            if (success) { ClearError(errorCount); return mapping; }

            mapping = ParseBlockMapping(out success);
            if (success) { ClearError(errorCount); return mapping; }

            return mapping;
        }

        private DataItem ParseIndentedBlockNode(out bool success)
        {
            int errorCount = Errors.Count;
            IncreaseIndent();
            DataItem dataItem = ParseIndentedBlock(out success);
            DecreaseIndent();
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse IndentedBlock of IndentedBlockNode."); }
            return dataItem;
        }

        private DataItem ParseSeparatedBlockNode(out bool success)
        {
            int errorCount = Errors.Count;
            IncreaseIndent();
            DataItem dataItem = ParseSeparatedBlock(out success);
            DecreaseIndent();
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse SeparatedBlock of SeparatedBlockNode."); }
            return dataItem;
        }

        private DataItem ParseIndentedBlock(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseIndentedContent(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position1 = position;
                ParseIndent(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of IndentedBlock.");
                    break;
                }

                dataItem = ParseAliasNode(out success);
                if (!success)
                {
                    Error("Failed to parse AliasNode of IndentedBlock.");
                    position = seq_start_position1;
                    break;
                }

                ParseInlineComments(out success);
                if (!success)
                {
                    Error("Failed to parse InlineComments of IndentedBlock.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position2 = position;
                ParseIndent(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of IndentedBlock.");
                    break;
                }

                NodeProperty property = ParseNodeProperty(out success);
                if (!success)
                {
                    Error("Failed to parse property of IndentedBlock.");
                    position = seq_start_position2;
                    break;
                }

                dataItem = ParseSeparatedContent(out success);
                if (success) { SetDataItemProperty(dataItem, property); }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseSeparatedBlock(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseSeparatedContent(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position1 = position;
                ParseSeparationLines(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationLines of SeparatedBlock.");
                    break;
                }

                dataItem = ParseAliasNode(out success);
                if (!success)
                {
                    Error("Failed to parse AliasNode of SeparatedBlock.");
                    position = seq_start_position1;
                    break;
                }

                ParseInlineComments(out success);
                if (!success)
                {
                    Error("Failed to parse InlineComments of SeparatedBlock.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position2 = position;
                ParseSeparationSpace(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationSpace of SeparatedBlock.");
                    break;
                }

                NodeProperty property = ParseNodeProperty(out success);
                if (!success)
                {
                    Error("Failed to parse property of SeparatedBlock.");
                    position = seq_start_position2;
                    break;
                }

                dataItem = ParseSeparatedContent(out success);
                if (success) { SetDataItemProperty(dataItem, property); }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseEmptyBlock(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseIndentedContent(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            while (true)
            {
                int seq_start_position1 = position;
                ParseIndent(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of IndentedContent.");
                    break;
                }

                dataItem = ParseBlockContent(out success);
                if (!success)
                {
                    Error("Failed to parse BlockContent of IndentedContent.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position2 = position;
                ParseIndent(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of IndentedContent.");
                    break;
                }

                dataItem = ParseFlowContentInBlock(out success);
                if (!success)
                {
                    Error("Failed to parse FlowContentInBlock of IndentedContent.");
                    position = seq_start_position2;
                    break;
                }

                ParseInlineComments(out success);
                if (!success)
                {
                    Error("Failed to parse InlineComments of IndentedContent.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseSeparatedContent(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            while (true)
            {
                int seq_start_position1 = position;
                ParseInlineComments(out success);
                if (!success)
                {
                    Error("Failed to parse InlineComments of SeparatedContent.");
                    break;
                }

                dataItem = ParseIndentedContent(out success);
                if (!success)
                {
                    Error("Failed to parse IndentedContent of SeparatedContent.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position2 = position;
                ParseSeparationSpace(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationSpace of SeparatedContent.");
                    break;
                }

                dataItem = ParseBlockScalar(out success);
                if (!success)
                {
                    Error("Failed to parse BlockScalar of SeparatedContent.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position3 = position;
                ParseSeparationSpace(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationSpace of SeparatedContent.");
                    break;
                }

                dataItem = ParseFlowContentInBlock(out success);
                if (!success)
                {
                    Error("Failed to parse FlowContentInBlock of SeparatedContent.");
                    position = seq_start_position3;
                    break;
                }

                ParseInlineComments(out success);
                if (!success)
                {
                    Error("Failed to parse InlineComments of SeparatedContent.");
                    position = seq_start_position3;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseBlockCollectionEntry(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            IncreaseIndent();
            while (true)
            {
                int seq_start_position1 = position;
                ParseSeparationSpaceAsIndent(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationSpaceAsIndent of BlockCollectionEntry.");
                    break;
                }

                dataItem = ParseBlockCollection(out success);
                if (!success)
                {
                    Error("Failed to parse BlockCollection of BlockCollectionEntry.");
                    position = seq_start_position1;
                }
                break;
            }
            DecreaseIndent();
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseSeparatedBlockNode(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseBlockCollectionEntryOptionalIndent(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            RememberIndent();
            while (true)
            {
                int seq_start_position1 = position;
                ParseSeparationSpaceAsIndent(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationSpaceAsIndent of BlockCollectionEntryOptionalIndent.");
                    break;
                }

                dataItem = ParseBlockCollection(out success);
                if (!success)
                {
                    Error("Failed to parse BlockCollection of BlockCollectionEntryOptionalIndent.");
                    position = seq_start_position1;
                }
                break;
            }
            RestoreIndent();
            if (success) { ClearError(errorCount); return dataItem; }

            RememberIndent();
            dataItem = ParseSeparatedBlock(out success);
            RestoreIndent();
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseFlowNodeInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseAliasNode(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseFlowContentInFlow(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position1 = position;
                NodeProperty property = ParseNodeProperty(out success);
                if (success) { dataItem = new Scalar(); }
                else
                {
                    Error("Failed to parse property of FlowNodeInFlow.");
                    break;
                }

                while (true)
                {
                    int seq_start_position2 = position;
                    ParseSeparationLinesInFlow(out success);
                    if (!success)
                    {
                        Error("Failed to parse SeparationLinesInFlow of FlowNodeInFlow.");
                        break;
                    }

                    dataItem = ParseFlowContentInFlow(out success);
                    if (!success)
                    {
                        Error("Failed to parse FlowContentInFlow of FlowNodeInFlow.");
                        position = seq_start_position2;
                    }
                    break;
                }
                if (success) { SetDataItemProperty(dataItem, property); }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseAliasNode(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            MatchTerminal('*', out success);
            if (!success)
            {
                Error("Failed to parse '*' of AliasNode.");
                position = start_position;
                return dataItem;
            }

            string name = ParseAnchorName(out success);
            if (success) { return GetAnchoredDataItem(name); }
            else
            {
                Error("Failed to parse name of AliasNode.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private DataItem ParseFlowContentInBlock(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseFlowScalarInBlock(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseFlowSequence(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseFlowMapping(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseFlowContentInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseFlowScalarInFlow(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseFlowSequence(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseFlowMapping(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseBlockContent(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseBlockScalar(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseBlockSequence(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseBlockMapping(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseBlockCollection(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            dataItem = ParseBlockSequence(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            dataItem = ParseBlockMapping(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseEmptyFlow(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = new DataItem();

            success = true;
            if (success) { return new Scalar(); }
            return dataItem;
        }

        private DataItem ParseEmptyBlock(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            dataItem = ParseEmptyFlow(out success);

            ParseInlineComments(out success);
            if (!success)
            {
                Error("Failed to parse InlineComments of EmptyBlock.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private NodeProperty ParseNodeProperty(out bool success)
        {
            int errorCount = Errors.Count;
            NodeProperty nodeProperty = new NodeProperty();

            while (true)
            {
                int seq_start_position1 = position;
                nodeProperty.Tag = ParseTag(out success);
                if (!success)
                {
                    Error("Failed to parse Tag of NodeProperty.");
                    break;
                }

                while (true)
                {
                    int seq_start_position2 = position;
                    ParseSeparationLines(out success);
                    if (!success)
                    {
                        Error("Failed to parse SeparationLines of NodeProperty.");
                        break;
                    }

                    nodeProperty.Anchor = ParseAnchor(out success);
                    if (!success)
                    {
                        Error("Failed to parse Anchor of NodeProperty.");
                        position = seq_start_position2;
                    }
                    break;
                }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return nodeProperty; }

            while (true)
            {
                int seq_start_position3 = position;
                nodeProperty.Anchor = ParseAnchor(out success);
                if (!success)
                {
                    Error("Failed to parse Anchor of NodeProperty.");
                    break;
                }

                while (true)
                {
                    int seq_start_position4 = position;
                    ParseSeparationLines(out success);
                    if (!success)
                    {
                        Error("Failed to parse SeparationLines of NodeProperty.");
                        break;
                    }

                    nodeProperty.Tag = ParseTag(out success);
                    if (!success)
                    {
                        Error("Failed to parse Tag of NodeProperty.");
                        position = seq_start_position4;
                    }
                    break;
                }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return nodeProperty; }

            return nodeProperty;
        }

        private string ParseAnchor(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;
            int start_position = position;

            MatchTerminal('&', out success);
            if (!success)
            {
                Error("Failed to parse '&' of Anchor.");
                position = start_position;
                return str;
            }

            str = ParseAnchorName(out success);
            if (!success)
            {
                Error("Failed to parse AnchorName of Anchor.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return str;
        }

        private string ParseAnchorName(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            int counter = 0;
            while (true)
            {
                char ch = ParseNonSpaceChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse (NonSpaceChar)+ of AnchorName."); }
            return text.ToString();
        }

        private Tag ParseTag(out bool success)
        {
            int errorCount = Errors.Count;
            Tag tag = null;

            tag = ParseVerbatimTag(out success);
            if (success) { ClearError(errorCount); return tag; }

            tag = ParseShorthandTag(out success);
            if (success) { ClearError(errorCount); return tag; }

            tag = ParseNonSpecificTag(out success);
            if (success) { ClearError(errorCount); return tag; }

            return tag;
        }

        private NonSpecificTag ParseNonSpecificTag(out bool success)
        {
            int errorCount = Errors.Count;
            NonSpecificTag nonSpecificTag = new NonSpecificTag();

            MatchTerminal('!', out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse '!' of NonSpecificTag."); }
            return nonSpecificTag;
        }

        private VerbatimTag ParseVerbatimTag(out bool success)
        {
            int errorCount = Errors.Count;
            VerbatimTag verbatimTag = new VerbatimTag();
            int start_position = position;

            MatchTerminal('!', out success);
            if (!success)
            {
                Error("Failed to parse '!' of VerbatimTag.");
                position = start_position;
                return verbatimTag;
            }

            MatchTerminal('<', out success);
            if (!success)
            {
                Error("Failed to parse '<' of VerbatimTag.");
                position = start_position;
                return verbatimTag;
            }

            int counter = 0;
            while (true)
            {
                char ch = ParseUriChar(out success);
                if (success) { verbatimTag.Chars.Add(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse Chars of VerbatimTag.");
                position = start_position;
                return verbatimTag;
            }

            MatchTerminal('>', out success);
            if (!success)
            {
                Error("Failed to parse '>' of VerbatimTag.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return verbatimTag;
        }

        private ShorthandTag ParseShorthandTag(out bool success)
        {
            int errorCount = Errors.Count;
            ShorthandTag shorthandTag = new ShorthandTag();

            while (true)
            {
                int seq_start_position1 = position;
                ParseNamedTagHandle(out success);
                if (!success)
                {
                    Error("Failed to parse NamedTagHandle of ShorthandTag.");
                    break;
                }

                int counter = 0;
                while (true)
                {
                    char ch = ParseTagChar(out success);
                    if (success) { shorthandTag.Chars.Add(ch); }
                    else { break; }
                    counter++;
                }
                if (counter > 0) { success = true; }
                if (!success)
                {
                    Error("Failed to parse Chars of ShorthandTag.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return shorthandTag; }

            while (true)
            {
                int seq_start_position2 = position;
                ParseSecondaryTagHandle(out success);
                if (!success)
                {
                    Error("Failed to parse SecondaryTagHandle of ShorthandTag.");
                    break;
                }

                int counter = 0;
                while (true)
                {
                    char ch = ParseTagChar(out success);
                    if (success) { shorthandTag.Chars.Add(ch); }
                    else { break; }
                    counter++;
                }
                if (counter > 0) { success = true; }
                if (!success)
                {
                    Error("Failed to parse Chars of ShorthandTag.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return shorthandTag; }

            while (true)
            {
                int seq_start_position3 = position;
                ParsePrimaryTagHandle(out success);
                if (!success)
                {
                    Error("Failed to parse PrimaryTagHandle of ShorthandTag.");
                    break;
                }

                int counter = 0;
                while (true)
                {
                    char ch = ParseTagChar(out success);
                    if (success) { shorthandTag.Chars.Add(ch); }
                    else { break; }
                    counter++;
                }
                if (counter > 0) { success = true; }
                if (!success)
                {
                    Error("Failed to parse Chars of ShorthandTag.");
                    position = seq_start_position3;
                }
                break;
            }
            if (success) { ClearError(errorCount); return shorthandTag; }

            return shorthandTag;
        }

        private Scalar ParseFlowScalarInBlock(out bool success)
        {
            int errorCount = Errors.Count;
            Scalar scalar = new Scalar();

            scalar.Text = ParsePlainTextMultiLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseSingleQuotedText(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseDoubleQuotedText(out success);
            if (success) { ClearError(errorCount); return scalar; }

            return scalar;
        }

        private Scalar ParseFlowScalarInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            Scalar scalar = new Scalar();

            scalar.Text = ParsePlainTextInFlow(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseSingleQuotedText(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseDoubleQuotedText(out success);
            if (success) { ClearError(errorCount); return scalar; }

            return scalar;
        }

        private Scalar ParseBlockScalar(out bool success)
        {
            int errorCount = Errors.Count;
            Scalar scalar = new Scalar();

            scalar.Text = ParseLiteralText(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseFoldedText(out success);
            if (success) { ClearError(errorCount); return scalar; }

            return scalar;
        }

        private string ParsePlainText(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;

            str = ParsePlainTextMultiLine(out success);
            if (success) { ClearError(errorCount); return str; }

            str = ParsePlainTextInFlow(out success);
            if (success) { ClearError(errorCount); return str; }

            return str;
        }

        private string ParsePlainTextMultiLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str = ParsePlainTextSingleLine(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse PlainTextSingleLine of PlainTextMultiLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                str = ParsePlainTextMoreLine(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParsePlainTextSingleLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            int not_start_position1 = position;
            ParseDocumentMarker(out success);
            position = not_start_position1;
            success = !success;
            if (!success)
            {
                Error("Failed to parse !(DocumentMarker) of PlainTextSingleLine.");
                position = start_position;
                return text.ToString();
            }

            string str = ParsePlainTextFirstChar(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse PlainTextFirstChar of PlainTextSingleLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    str = ParsePlainTextChar(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    str = ParseSpacedPlainTextChar(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParsePlainTextMoreLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIgnoredBlank(out success);

            string str = ParseLineFolding(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse LineFolding of PlainTextMoreLine.");
                position = start_position;
                return text.ToString();
            }

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of PlainTextMoreLine.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredSpace(out success);

            int counter = 0;
            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    str = ParsePlainTextChar(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    str = ParseSpacedPlainTextChar(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse ((PlainTextChar / SpacedPlainTextChar))+ of PlainTextMoreLine.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParsePlainTextInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str = ParsePlainTextInFlowSingleLine(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse PlainTextInFlowSingleLine of PlainTextInFlow.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                str = ParsePlainTextInFlowMoreLine(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParsePlainTextInFlowSingleLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            int not_start_position1 = position;
            ParseDocumentMarker(out success);
            position = not_start_position1;
            success = !success;
            if (!success)
            {
                Error("Failed to parse !(DocumentMarker) of PlainTextInFlowSingleLine.");
                position = start_position;
                return text.ToString();
            }

            string str = ParsePlainTextFirstCharInFlow(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse PlainTextFirstCharInFlow of PlainTextInFlowSingleLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    str = ParsePlainTextCharInFlow(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    str = ParseSpacedPlainTextCharInFlow(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParsePlainTextInFlowMoreLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIgnoredBlank(out success);

            string str = ParseLineFolding(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse LineFolding of PlainTextInFlowMoreLine.");
                position = start_position;
                return text.ToString();
            }

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of PlainTextInFlowMoreLine.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredSpace(out success);

            int counter = 0;
            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    str = ParsePlainTextCharInFlow(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    str = ParseSpacedPlainTextCharInFlow(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(str);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse ((PlainTextCharInFlow / SpacedPlainTextCharInFlow))+ of PlainTextInFlowMoreLine.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParsePlainTextFirstChar(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            char ch = MatchTerminalSet("\r\n\t -?:,[]{}#&*!|>'\"%@`", true, out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(ch);
                return text.ToString();
            }

            while (true)
            {
                int seq_start_position1 = position;
                ch = MatchTerminalSet("-?:", false, out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse \"-?:\" of PlainTextFirstChar.");
                    break;
                }

                ch = ParseNonSpaceChar(out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse NonSpaceChar of PlainTextFirstChar.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return text.ToString(); }

            return text.ToString();
        }

        private string ParsePlainTextChar(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            while (true)
            {
                int seq_start_position1 = position;
                char ch = MatchTerminal(':', out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse ':' of PlainTextChar.");
                    break;
                }

                ch = ParseNonSpaceChar(out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse NonSpaceChar of PlainTextChar.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return text.ToString(); }

            while (true)
            {
                int seq_start_position2 = position;
                char ch = ParseNonSpaceChar(out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse NonSpaceChar of PlainTextChar.");
                    break;
                }

                int counter = 0;
                while (true)
                {
                    ch = MatchTerminal('#', out success);
                    if (success) { text.Append(ch); }
                    else { break; }
                    counter++;
                }
                if (counter > 0) { success = true; }
                if (!success)
                {
                    Error("Failed to parse ('#')+ of PlainTextChar.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return text.ToString(); }

            text.Length = 0;
            char ch2 = MatchTerminalSet("\r\n\t :#", true, out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(ch2);
                return text.ToString();
            }

            return text.ToString();
        }

        private string ParseSpacedPlainTextChar(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            int counter = 0;
            while (true)
            {
                char ch = MatchTerminal(' ', out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse (' ')+ of SpacedPlainTextChar.");
                position = start_position;
                return text.ToString();
            }

            string str = ParsePlainTextChar(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse PlainTextChar of SpacedPlainTextChar.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParsePlainTextFirstCharInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            char ch = MatchTerminalSet("\r\n\t -?:,[]{}#&*!|>'\"%@`", true, out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(ch);
                return text.ToString();
            }

            while (true)
            {
                int seq_start_position1 = position;
                ch = MatchTerminalSet("-?:", false, out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse \"-?:\" of PlainTextFirstCharInFlow.");
                    break;
                }

                ch = ParseNonSpaceSep(out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse NonSpaceSep of PlainTextFirstCharInFlow.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return text.ToString(); }

            return text.ToString();
        }

        private string ParsePlainTextCharInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            while (true)
            {
                int seq_start_position1 = position;
                char ch = MatchTerminalSet(":", false, out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse \":\" of PlainTextCharInFlow.");
                    break;
                }

                ch = ParseNonSpaceSep(out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse NonSpaceSep of PlainTextCharInFlow.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return text.ToString(); }

            while (true)
            {
                int seq_start_position2 = position;
                char ch = ParseNonSpaceSep(out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse NonSpaceSep of PlainTextCharInFlow.");
                    break;
                }

                ch = MatchTerminal('#', out success);
                if (success) { text.Append(ch); }
                else
                {
                    Error("Failed to parse '#' of PlainTextCharInFlow.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return text.ToString(); }

            text.Length = 0;
            char ch2 = MatchTerminalSet("\r\n\t :#,[]{}", true, out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(ch2);
                return text.ToString();
            }

            return text.ToString();
        }

        private string ParseSpacedPlainTextCharInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            int counter = 0;
            while (true)
            {
                char ch = MatchTerminal(' ', out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse (' ')+ of SpacedPlainTextCharInFlow.");
                position = start_position;
                return text.ToString();
            }

            string str = ParsePlainTextCharInFlow(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse PlainTextCharInFlow of SpacedPlainTextCharInFlow.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private void ParseDocumentMarker(out bool success)
        {
            int errorCount = Errors.Count;
            while (true)
            {
                int seq_start_position1 = position;
                success = position == 0 || TerminalMatch('\n', position-1);
                if (!success)
                {
                    Error("Failed to parse sol of DocumentMarker.");
                    break;
                }

                MatchTerminalString("---", out success);
                if (!success)
                {
                    Error("Failed to parse '---' of DocumentMarker.");
                    position = seq_start_position1;
                    break;
                }

                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    ParseSpace(out success);
                    if (success) { ClearError(errorCount); break; }

                    ParseLineBreak(out success);
                    if (success) { ClearError(errorCount); break; }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success)
                {
                    Error("Failed to parse (Space / LineBreak) of DocumentMarker.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return; }

            while (true)
            {
                int seq_start_position2 = position;
                success = position == 0 || TerminalMatch('\n', position-1);
                if (!success)
                {
                    Error("Failed to parse sol of DocumentMarker.");
                    break;
                }

                MatchTerminalString("...", out success);
                if (!success)
                {
                    Error("Failed to parse '...' of DocumentMarker.");
                    position = seq_start_position2;
                    break;
                }

                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    ParseSpace(out success);
                    if (success) { ClearError(errorCount); break; }

                    ParseLineBreak(out success);
                    if (success) { ClearError(errorCount); break; }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success)
                {
                    Error("Failed to parse (Space / LineBreak) of DocumentMarker.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return; }

        }

        private string ParseDoubleQuotedText(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;

            str = ParseDoubleQuotedSingleLine(out success);
            if (success) { ClearError(errorCount); return str; }

            str = ParseDoubleQuotedMultiLine(out success);
            if (success) { ClearError(errorCount); return str; }

            return str;
        }

        private string ParseDoubleQuotedSingleLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            MatchTerminal('"', out success);
            if (!success)
            {
                Error("Failed to parse '\\\"' of DoubleQuotedSingleLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet("\"\\\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapeSequence(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            MatchTerminal('"', out success);
            if (!success)
            {
                Error("Failed to parse '\\\"' of DoubleQuotedSingleLine.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseDoubleQuotedMultiLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str = ParseDoubleQuotedMultiLineFist(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse DoubleQuotedMultiLineFist of DoubleQuotedMultiLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                str = ParseDoubleQuotedMultiLineInner(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            str = ParseDoubleQuotedMultiLineLast(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse DoubleQuotedMultiLineLast of DoubleQuotedMultiLine.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseDoubleQuotedMultiLineFist(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            MatchTerminal('"', out success);
            if (!success)
            {
                Error("Failed to parse '\\\"' of DoubleQuotedMultiLineFist.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet(" \"\\\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapeSequence(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    while (true)
                    {
                        int seq_start_position1 = position;
                        ch = MatchTerminal(' ', out success);
                        if (success) { text.Append(ch); }
                        else
                        {
                            Error("Failed to parse ' ' of DoubleQuotedMultiLineFist.");
                            break;
                        }

                        int not_start_position2 = position;
                        while (true)
                        {
                            ParseIgnoredBlank(out success);

                            ParseLineBreak(out success);
                            break;
                        }
                        position = not_start_position2;
                        success = !success;
                        if (!success)
                        {
                            Error("Failed to parse !((IgnoredBlank LineBreak)) of DoubleQuotedMultiLineFist.");
                            position = seq_start_position1;
                        }
                        break;
                    }
                    if (success) { ClearError(errorCount); break; }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            ParseIgnoredBlank(out success);

            string str = ParseDoubleQuotedMultiLineBreak(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse DoubleQuotedMultiLineBreak of DoubleQuotedMultiLineFist.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseDoubleQuotedMultiLineInner(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of DoubleQuotedMultiLineInner.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredBlank(out success);

            int counter = 0;
            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet(" \"\\\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapeSequence(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    while (true)
                    {
                        int seq_start_position1 = position;
                        ch = MatchTerminal(' ', out success);
                        if (success) { text.Append(ch); }
                        else
                        {
                            Error("Failed to parse ' ' of DoubleQuotedMultiLineInner.");
                            break;
                        }

                        int not_start_position2 = position;
                        while (true)
                        {
                            ParseIgnoredBlank(out success);

                            ParseLineBreak(out success);
                            break;
                        }
                        position = not_start_position2;
                        success = !success;
                        if (!success)
                        {
                            Error("Failed to parse !((IgnoredBlank LineBreak)) of DoubleQuotedMultiLineInner.");
                            position = seq_start_position1;
                        }
                        break;
                    }
                    if (success) { ClearError(errorCount); break; }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse ((-\" \"\\\r\n\" / EscapeSequence / ' ' !((IgnoredBlank LineBreak))))+ of DoubleQuotedMultiLineInner.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredBlank(out success);

            string str = ParseDoubleQuotedMultiLineBreak(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse DoubleQuotedMultiLineBreak of DoubleQuotedMultiLineInner.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseDoubleQuotedMultiLineLast(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of DoubleQuotedMultiLineLast.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredBlank(out success);

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet("\"\\\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapeSequence(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            MatchTerminal('"', out success);
            if (!success)
            {
                Error("Failed to parse '\\\"' of DoubleQuotedMultiLineLast.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseDoubleQuotedMultiLineBreak(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;

            str = ParseLineFolding(out success);
            if (success) { ClearError(errorCount); return str; }

            ParseEscapedLineBreak(out success);
            if (success) { ClearError(errorCount); return str; }

            return str;
        }

        private string ParseSingleQuotedText(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;

            str = ParseSingleQuotedSingleLine(out success);
            if (success) { ClearError(errorCount); return str; }

            str = ParseSingleQuotedMultiLine(out success);
            if (success) { ClearError(errorCount); return str; }

            return str;
        }

        private string ParseSingleQuotedSingleLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            MatchTerminal('\'', out success);
            if (!success)
            {
                Error("Failed to parse ''' of SingleQuotedSingleLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet("'\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapedSingleQuote(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            MatchTerminal('\'', out success);
            if (!success)
            {
                Error("Failed to parse ''' of SingleQuotedSingleLine.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseSingleQuotedMultiLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str = ParseSingleQuotedMultiLineFist(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse SingleQuotedMultiLineFist of SingleQuotedMultiLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                str = ParseSingleQuotedMultiLineInner(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            str = ParseSingleQuotedMultiLineLast(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse SingleQuotedMultiLineLast of SingleQuotedMultiLine.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseSingleQuotedMultiLineFist(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            MatchTerminal('\'', out success);
            if (!success)
            {
                Error("Failed to parse ''' of SingleQuotedMultiLineFist.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet(" '\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapedSingleQuote(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    while (true)
                    {
                        int seq_start_position1 = position;
                        ch = MatchTerminal(' ', out success);
                        if (success) { text.Append(ch); }
                        else
                        {
                            Error("Failed to parse ' ' of SingleQuotedMultiLineFist.");
                            break;
                        }

                        int not_start_position2 = position;
                        while (true)
                        {
                            ParseIgnoredBlank(out success);

                            ParseLineBreak(out success);
                            break;
                        }
                        position = not_start_position2;
                        success = !success;
                        if (!success)
                        {
                            Error("Failed to parse !((IgnoredBlank LineBreak)) of SingleQuotedMultiLineFist.");
                            position = seq_start_position1;
                        }
                        break;
                    }
                    if (success) { ClearError(errorCount); break; }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            ParseIgnoredBlank(out success);

            string fold = ParseLineFolding(out success);
            if (success) { text.Append(fold); }
            else
            {
                Error("Failed to parse fold of SingleQuotedMultiLineFist.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseSingleQuotedMultiLineInner(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of SingleQuotedMultiLineInner.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredBlank(out success);

            int counter = 0;
            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet(" '\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapedSingleQuote(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    while (true)
                    {
                        int seq_start_position1 = position;
                        ch = MatchTerminal(' ', out success);
                        if (success) { text.Append(ch); }
                        else
                        {
                            Error("Failed to parse ' ' of SingleQuotedMultiLineInner.");
                            break;
                        }

                        int not_start_position2 = position;
                        while (true)
                        {
                            ParseIgnoredBlank(out success);

                            ParseLineBreak(out success);
                            break;
                        }
                        position = not_start_position2;
                        success = !success;
                        if (!success)
                        {
                            Error("Failed to parse !((IgnoredBlank LineBreak)) of SingleQuotedMultiLineInner.");
                            position = seq_start_position1;
                        }
                        break;
                    }
                    if (success) { ClearError(errorCount); break; }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse ((-\" '\r\n\" / EscapedSingleQuote / ' ' !((IgnoredBlank LineBreak))))+ of SingleQuotedMultiLineInner.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredBlank(out success);

            string fold = ParseLineFolding(out success);
            if (success) { text.Append(fold); }
            else
            {
                Error("Failed to parse fold of SingleQuotedMultiLineInner.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseSingleQuotedMultiLineLast(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of SingleQuotedMultiLineLast.");
                position = start_position;
                return text.ToString();
            }

            ParseIgnoredBlank(out success);

            while (true)
            {
                ErrorStatck.Push(errorCount); errorCount = Errors.Count;
                while (true)
                {
                    char ch = MatchTerminalSet("'\r\n", true, out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    ch = ParseEscapedSingleQuote(out success);
                    if (success)
                    {
                        ClearError(errorCount);
                        text.Append(ch);
                        break;
                    }

                    break;
                }
                errorCount = ErrorStatck.Pop();
                if (!success) { break; }
            }
            success = true;

            MatchTerminal('\'', out success);
            if (!success)
            {
                Error("Failed to parse ''' of SingleQuotedMultiLineLast.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseLineFolding(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;

            while (true)
            {
                int seq_start_position1 = position;
                str = ParseReservedLineBreak(out success);
                if (!success)
                {
                    Error("Failed to parse ReservedLineBreak of LineFolding.");
                    break;
                }

                int counter = 0;
                while (true)
                {
                    while (true)
                    {
                        int seq_start_position2 = position;
                        ParseIgnoredBlank(out success);

                        ParseLineBreak(out success);
                        if (!success)
                        {
                            Error("Failed to parse LineBreak of LineFolding.");
                            position = seq_start_position2;
                        }
                        break;
                    }
                    if (!success) { break; }
                    counter++;
                }
                if (counter > 0) { success = true; }
                if (!success)
                {
                    Error("Failed to parse ((IgnoredBlank LineBreak))+ of LineFolding.");
                    position = seq_start_position1;
                    break;
                }

                int and_start_position3 = position;
                ParseIndent(out success);
                position = and_start_position3;
                if (!success)
                {
                    Error("Failed to parse &(Indent) of LineFolding.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return str; }

            while (true)
            {
                int seq_start_position4 = position;
                ParseLineBreak(out success);
                if (!success)
                {
                    Error("Failed to parse LineBreak of LineFolding.");
                    break;
                }

                int and_start_position5 = position;
                ParseIndent(out success);
                position = and_start_position5;
                if (success) { return " "; }
                else
                {
                    Error("Failed to parse &(Indent) of LineFolding.");
                    position = seq_start_position4;
                }
                break;
            }
            if (success) { ClearError(errorCount); return str; }

            return str;
        }

        private char ParseEscapedSingleQuote(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);
            MatchTerminalString("''", out success);
            if (success) { ClearError(errorCount); return '\''; }
            else { Error("Failed to parse '''' of EscapedSingleQuote."); }
            return ch;
        }

        private void ParseEscapedLineBreak(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            MatchTerminal('\\', out success);
            if (!success)
            {
                Error("Failed to parse '\\\\' of EscapedLineBreak.");
                position = start_position;
                return;
            }

            ParseLineBreak(out success);
            if (!success)
            {
                Error("Failed to parse LineBreak of EscapedLineBreak.");
                position = start_position;
                return;
            }

            while (true)
            {
                while (true)
                {
                    int seq_start_position1 = position;
                    ParseIgnoredBlank(out success);

                    ParseLineBreak(out success);
                    if (!success)
                    {
                        Error("Failed to parse LineBreak of EscapedLineBreak.");
                        position = seq_start_position1;
                    }
                    break;
                }
                if (!success) { break; }
            }
            success = true;

        }

        private string ParseLiteralText(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            MatchTerminal('|', out success);
            if (!success)
            {
                Error("Failed to parse '|' of LiteralText.");
                position = start_position;
                return text.ToString();
            }

            BlockScalarModifier modifier = ParseBlockScalarModifier(out success);
            AddIndent(modifier, success);
            success = true;

            ParseInlineComment(out success);
            if (!success)
            {
                Error("Failed to parse InlineComment of LiteralText.");
                position = start_position;
                return text.ToString();
            }

            string str = ParseLiteralContent(out success);
            DecreaseIndent();
            if (success) { text.Append(str); }
            success = true;

            return text.ToString();
        }

        private string ParseFoldedText(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            MatchTerminal('>', out success);
            if (!success)
            {
                Error("Failed to parse '>' of FoldedText.");
                position = start_position;
                return text.ToString();
            }

            BlockScalarModifier modifier = ParseBlockScalarModifier(out success);
            AddIndent(modifier, success);
            success = true;

            ParseInlineComment(out success);
            if (!success)
            {
                Error("Failed to parse InlineComment of FoldedText.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                int seq_start_position1 = position;
                while (true)
                {
                    string str_2 = ParseEmptyLineBlock(out success);
                    if (success) { text.Append(str_2); }
                    else { break; }
                }
                success = true;

                string str = ParseFoldedLines(out success);
                if (success) { text.Append(str); }
                else
                {
                    Error("Failed to parse FoldedLines of FoldedText.");
                    position = seq_start_position1;
                    break;
                }

                str = ParseChompedLineBreak(out success);
                if (success) { text.Append(str); }
                else
                {
                    Error("Failed to parse ChompedLineBreak of FoldedText.");
                    position = seq_start_position1;
                    break;
                }

                ParseComments(out success);
                success = true;
                break;
            }
            DecreaseIndent();
            if (!success)
            {
                Error("Failed to parse (((EmptyLineBlock))* FoldedLines ChompedLineBreak (Comments)?) of FoldedText.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private BlockScalarModifier ParseBlockScalarModifier(out bool success)
        {
            int errorCount = Errors.Count;
            BlockScalarModifier blockScalarModifier = new BlockScalarModifier();

            while (true)
            {
                int seq_start_position1 = position;
                blockScalarModifier.Indent = ParseIndentIndicator(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of BlockScalarModifier.");
                    break;
                }

                blockScalarModifier.Chomp = ParseChompingIndicator(out success);
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return blockScalarModifier; }

            while (true)
            {
                int seq_start_position2 = position;
                blockScalarModifier.Chomp = ParseChompingIndicator(out success);
                if (!success)
                {
                    Error("Failed to parse Chomp of BlockScalarModifier.");
                    break;
                }

                blockScalarModifier.Indent = ParseIndentIndicator(out success);
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return blockScalarModifier; }

            return blockScalarModifier;
        }

        private string ParseLiteralContent(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str = ParseLiteralFirst(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse LiteralFirst of LiteralContent.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                str = ParseLiteralInner(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            string str2 = ParseChompedLineBreak(out success);
            if (success) { text.Append(str2); }
            else
            {
                Error("Failed to parse str2 of LiteralContent.");
                position = start_position;
                return text.ToString();
            }

            ParseComments(out success);
            success = true;

            return text.ToString();
        }

        private string ParseLiteralFirst(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            while (true)
            {
                string str = ParseEmptyLineBlock(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of LiteralFirst.");
                position = start_position;
                return text.ToString();
            }

            int counter = 0;
            while (true)
            {
                char ch = ParseNonBreakChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse (NonBreakChar)+ of LiteralFirst.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseLiteralInner(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str = ParseReservedLineBreak(out success);
            if (success) { text.Append(str); }
            else
            {
                Error("Failed to parse ReservedLineBreak of LiteralInner.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                str = ParseEmptyLineBlock(out success);
                if (success) { text.Append(str); }
                else { break; }
            }
            success = true;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of LiteralInner.");
                position = start_position;
                return text.ToString();
            }

            int counter = 0;
            while (true)
            {
                char ch = ParseNonBreakChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (!success)
            {
                Error("Failed to parse (NonBreakChar)+ of LiteralInner.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return text.ToString();
        }

        private string ParseFoldedLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of FoldedLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                char ch = ParseNonBreakChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParseFoldedLines(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str2 = ParseFoldedLine(out success);
            if (success) { text.Append(str2); }
            else
            {
                Error("Failed to parse str2 of FoldedLines.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                while (true)
                {
                    int seq_start_position1 = position;
                    string str = ParseLineFolding(out success);
                    if (success) { text.Append(str); }
                    else
                    {
                        Error("Failed to parse LineFolding of FoldedLines.");
                        break;
                    }

                    str = ParseFoldedLine(out success);
                    if (success) { text.Append(str); }
                    else
                    {
                        Error("Failed to parse FoldedLine of FoldedLines.");
                        position = seq_start_position1;
                    }
                    break;
                }
                if (!success) { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParseSpacedLine(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of SpacedLine.");
                position = start_position;
                return text.ToString();
            }

            ParseBlank(out success);
            if (!success)
            {
                Error("Failed to parse Blank of SpacedLine.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                char ch = ParseNonBreakChar(out success);
                if (success) { text.Append(ch); }
                else { break; }
            }
            success = true;

            return text.ToString();
        }

        private string ParseSpacedLines(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();
            int start_position = position;

            string str2 = ParseSpacedLine(out success);
            if (success) { text.Append(str2); }
            else
            {
                Error("Failed to parse str2 of SpacedLines.");
                position = start_position;
                return text.ToString();
            }

            while (true)
            {
                while (true)
                {
                    int seq_start_position1 = position;
                    ParseLineBreak(out success);
                    if (!success)
                    {
                        Error("Failed to parse LineBreak of SpacedLines.");
                        break;
                    }

                    string str = ParseSpacedLine(out success);
                    if (success) { text.Append(str); }
                    else
                    {
                        Error("Failed to parse SpacedLine of SpacedLines.");
                        position = seq_start_position1;
                    }
                    break;
                }
                if (!success) { break; }
            }
            success = true;

            return text.ToString();
        }

        private char ParseIndentIndicator(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminalRange('1', '9', out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse '1'...'9' of IndentIndicator."); }
            return ch;
        }

        private char ParseChompingIndicator(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            ch = MatchTerminal('-', out success);
            if (success) { ClearError(errorCount); return ch; }

            ch = MatchTerminal('+', out success);
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

        private Sequence ParseFlowSequence(out bool success)
        {
            int errorCount = Errors.Count;
            Sequence sequence = new Sequence();
            int start_position = position;

            MatchTerminal('[', out success);
            if (!success)
            {
                Error("Failed to parse '[' of FlowSequence.");
                position = start_position;
                return sequence;
            }

            ParseSeparationLinesInFlow(out success);
            success = true;

            while (true)
            {
                int seq_start_position1 = position;
                DataItem dataItem = ParseFlowSequenceEntry(out success);
                if (success) { sequence.Enties.Add(dataItem); }
                else
                {
                    Error("Failed to parse FlowSequenceEntry of FlowSequence.");
                    break;
                }

                while (true)
                {
                    while (true)
                    {
                        int seq_start_position2 = position;
                        MatchTerminal(',', out success);
                        if (!success)
                        {
                            Error("Failed to parse ',' of FlowSequence.");
                            break;
                        }

                        ParseSeparationLinesInFlow(out success);
                        success = true;

                        dataItem = ParseFlowSequenceEntry(out success);
                        if (success) { sequence.Enties.Add(dataItem); }
                        else
                        {
                            Error("Failed to parse FlowSequenceEntry of FlowSequence.");
                            position = seq_start_position2;
                        }
                        break;
                    }
                    if (!success) { break; }
                }
                success = true;
                break;
            }
            if (!success)
            {
                Error("Failed to parse Enties of FlowSequence.");
                position = start_position;
                return sequence;
            }

            MatchTerminal(']', out success);
            if (!success)
            {
                Error("Failed to parse ']' of FlowSequence.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return sequence;
        }

        private DataItem ParseFlowSequenceEntry(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            while (true)
            {
                int seq_start_position1 = position;
                dataItem = ParseFlowNodeInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse FlowNodeInFlow of FlowSequenceEntry.");
                    break;
                }

                ParseSeparationLinesInFlow(out success);
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            ParseFlowSingPair(out success);
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private Sequence ParseBlockSequence(out bool success)
        {
            int errorCount = Errors.Count;
            Sequence sequence = new Sequence();

            while (true)
            {
                int seq_start_position1 = position;
                DataItem dataItem = ParseBlockSequenceEntry(out success);
                if (success) { sequence.Enties.Add(dataItem); }
                else
                {
                    Error("Failed to parse BlockSequenceEntry of BlockSequence.");
                    break;
                }

                while (true)
                {
                    while (true)
                    {
                        int seq_start_position2 = position;
                        ParseIndent(out success);
                        if (!success)
                        {
                            Error("Failed to parse Indent of BlockSequence.");
                            break;
                        }

                        dataItem = ParseBlockSequenceEntry(out success);
                        if (success) { sequence.Enties.Add(dataItem); }
                        else
                        {
                            Error("Failed to parse BlockSequenceEntry of BlockSequence.");
                            position = seq_start_position2;
                        }
                        break;
                    }
                    if (!success) { break; }
                }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse Enties of BlockSequence."); }
            return sequence;
        }

        private DataItem ParseBlockSequenceEntry(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            MatchTerminal('-', out success);
            if (!success)
            {
                Error("Failed to parse '-' of BlockSequenceEntry.");
                position = start_position;
                return dataItem;
            }

            dataItem = ParseBlockCollectionEntry(out success);
            if (!success)
            {
                Error("Failed to parse BlockCollectionEntry of BlockSequenceEntry.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private Mapping ParseFlowMapping(out bool success)
        {
            int errorCount = Errors.Count;
            Mapping mapping = new Mapping();
            int start_position = position;

            MatchTerminal('{', out success);
            if (!success)
            {
                Error("Failed to parse '{' of FlowMapping.");
                position = start_position;
                return mapping;
            }

            ParseSeparationLinesInFlow(out success);
            success = true;

            while (true)
            {
                int seq_start_position1 = position;
                MappingEntry mappingEntry = ParseFlowMappingEntry(out success);
                if (success) { mapping.Enties.Add(mappingEntry); }
                else
                {
                    Error("Failed to parse FlowMappingEntry of FlowMapping.");
                    break;
                }

                while (true)
                {
                    while (true)
                    {
                        int seq_start_position2 = position;
                        MatchTerminal(',', out success);
                        if (!success)
                        {
                            Error("Failed to parse ',' of FlowMapping.");
                            break;
                        }

                        ParseSeparationLinesInFlow(out success);
                        success = true;

                        mappingEntry = ParseFlowMappingEntry(out success);
                        if (success) { mapping.Enties.Add(mappingEntry); }
                        else
                        {
                            Error("Failed to parse FlowMappingEntry of FlowMapping.");
                            position = seq_start_position2;
                        }
                        break;
                    }
                    if (!success) { break; }
                }
                success = true;
                break;
            }
            if (!success)
            {
                Error("Failed to parse Enties of FlowMapping.");
                position = start_position;
                return mapping;
            }

            MatchTerminal('}', out success);
            if (!success)
            {
                Error("Failed to parse '}' of FlowMapping.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return mapping;
        }

        private MappingEntry ParseFlowMappingEntry(out bool success)
        {
            int errorCount = Errors.Count;
            MappingEntry mappingEntry = new MappingEntry();

            while (true)
            {
                int seq_start_position1 = position;
                mappingEntry.Key = ParseExplicitKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseExplicitValue(out success);
                if (!success)
                {
                    Error("Failed to parse Value of FlowMappingEntry.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position2 = position;
                mappingEntry.Key = ParseExplicitKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseEmptyFlow(out success);
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position3 = position;
                mappingEntry.Key = ParseSimpleKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseExplicitValue(out success);
                if (!success)
                {
                    Error("Failed to parse Value of FlowMappingEntry.");
                    position = seq_start_position3;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position4 = position;
                mappingEntry.Key = ParseSimpleKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseEmptyFlow(out success);
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            return mappingEntry;
        }

        private DataItem ParseExplicitKey(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            while (true)
            {
                int seq_start_position1 = position;
                MatchTerminal('?', out success);
                if (!success)
                {
                    Error("Failed to parse '?' of ExplicitKey.");
                    break;
                }

                ParseSeparationLinesInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationLinesInFlow of ExplicitKey.");
                    position = seq_start_position1;
                    break;
                }

                dataItem = ParseFlowNodeInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse FlowNodeInFlow of ExplicitKey.");
                    position = seq_start_position1;
                    break;
                }

                ParseSeparationLinesInFlow(out success);
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position2 = position;
                MatchTerminal('?', out success);
                if (!success)
                {
                    Error("Failed to parse '?' of ExplicitKey.");
                    break;
                }

                dataItem = ParseEmptyFlow(out success);

                ParseSeparationLinesInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationLinesInFlow of ExplicitKey.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private DataItem ParseSimpleKey(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            dataItem = ParseFlowKey(out success);
            if (!success)
            {
                Error("Failed to parse FlowKey of SimpleKey.");
                position = start_position;
                return dataItem;
            }

            ParseSeparationLinesInFlow(out success);
            success = true;

            return dataItem;
        }

        private Scalar ParseFlowKey(out bool success)
        {
            int errorCount = Errors.Count;
            Scalar scalar = new Scalar();

            scalar.Text = ParsePlainTextInFlowSingleLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseDoubleQuotedSingleLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseSingleQuotedSingleLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            return scalar;
        }

        private Scalar ParseBlockKey(out bool success)
        {
            int errorCount = Errors.Count;
            Scalar scalar = new Scalar();

            scalar.Text = ParsePlainTextSingleLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseDoubleQuotedSingleLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            scalar.Text = ParseSingleQuotedSingleLine(out success);
            if (success) { ClearError(errorCount); return scalar; }

            return scalar;
        }

        private DataItem ParseExplicitValue(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;

            while (true)
            {
                int seq_start_position1 = position;
                MatchTerminal(':', out success);
                if (!success)
                {
                    Error("Failed to parse ':' of ExplicitValue.");
                    break;
                }

                ParseSeparationLinesInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationLinesInFlow of ExplicitValue.");
                    position = seq_start_position1;
                    break;
                }

                dataItem = ParseFlowNodeInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse FlowNodeInFlow of ExplicitValue.");
                    position = seq_start_position1;
                    break;
                }

                ParseSeparationLinesInFlow(out success);
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            while (true)
            {
                int seq_start_position2 = position;
                MatchTerminal(':', out success);
                if (!success)
                {
                    Error("Failed to parse ':' of ExplicitValue.");
                    break;
                }

                dataItem = ParseEmptyFlow(out success);

                ParseSeparationLinesInFlow(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationLinesInFlow of ExplicitValue.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return dataItem; }

            return dataItem;
        }

        private MappingEntry ParseFlowSingPair(out bool success)
        {
            int errorCount = Errors.Count;
            MappingEntry mappingEntry = new MappingEntry();

            while (true)
            {
                int seq_start_position1 = position;
                mappingEntry.Key = ParseExplicitKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowSingPair.");
                    break;
                }

                mappingEntry.Value = ParseExplicitValue(out success);
                if (!success)
                {
                    Error("Failed to parse Value of FlowSingPair.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position2 = position;
                mappingEntry.Key = ParseExplicitKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowSingPair.");
                    break;
                }

                mappingEntry.Value = ParseEmptyFlow(out success);
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position3 = position;
                mappingEntry.Key = ParseSimpleKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of FlowSingPair.");
                    break;
                }

                mappingEntry.Value = ParseExplicitValue(out success);
                if (!success)
                {
                    Error("Failed to parse Value of FlowSingPair.");
                    position = seq_start_position3;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            return mappingEntry;
        }

        private Mapping ParseBlockMapping(out bool success)
        {
            int errorCount = Errors.Count;
            Mapping mapping = new Mapping();

            while (true)
            {
                int seq_start_position1 = position;
                MappingEntry mappingEntry = ParseBlockMappingEntry(out success);
                if (success) { mapping.Enties.Add(mappingEntry); }
                else
                {
                    Error("Failed to parse BlockMappingEntry of BlockMapping.");
                    break;
                }

                while (true)
                {
                    while (true)
                    {
                        int seq_start_position2 = position;
                        ParseIndent(out success);
                        if (!success)
                        {
                            Error("Failed to parse Indent of BlockMapping.");
                            break;
                        }

                        mappingEntry = ParseBlockMappingEntry(out success);
                        if (success) { mapping.Enties.Add(mappingEntry); }
                        else
                        {
                            Error("Failed to parse BlockMappingEntry of BlockMapping.");
                            position = seq_start_position2;
                        }
                        break;
                    }
                    if (!success) { break; }
                }
                success = true;
                break;
            }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse Enties of BlockMapping."); }
            return mapping;
        }

        private MappingEntry ParseBlockMappingEntry(out bool success)
        {
            int errorCount = Errors.Count;
            MappingEntry mappingEntry = new MappingEntry();

            while (true)
            {
                int seq_start_position1 = position;
                mappingEntry.Key = ParseBlockExplicitKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of BlockMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseBlockExplicitValue(out success);
                if (!success)
                {
                    Error("Failed to parse Value of BlockMappingEntry.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position2 = position;
                mappingEntry.Key = ParseBlockExplicitKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of BlockMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseEmptyFlow(out success);
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position3 = position;
                mappingEntry.Key = ParseBlockSimpleKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of BlockMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseBlockSimpleValue(out success);
                if (!success)
                {
                    Error("Failed to parse Value of BlockMappingEntry.");
                    position = seq_start_position3;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            while (true)
            {
                int seq_start_position4 = position;
                mappingEntry.Key = ParseBlockSimpleKey(out success);
                if (!success)
                {
                    Error("Failed to parse Key of BlockMappingEntry.");
                    break;
                }

                mappingEntry.Value = ParseEmptyBlock(out success);
                if (!success)
                {
                    Error("Failed to parse Value of BlockMappingEntry.");
                    position = seq_start_position4;
                }
                break;
            }
            if (success) { ClearError(errorCount); return mappingEntry; }

            return mappingEntry;
        }

        private DataItem ParseBlockExplicitKey(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            MatchTerminal('?', out success);
            if (!success)
            {
                Error("Failed to parse '?' of BlockExplicitKey.");
                position = start_position;
                return dataItem;
            }

            dataItem = ParseBlockCollectionEntry(out success);
            if (!success)
            {
                Error("Failed to parse BlockCollectionEntry of BlockExplicitKey.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private DataItem ParseBlockExplicitValue(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            ParseIndent(out success);
            if (!success)
            {
                Error("Failed to parse Indent of BlockExplicitValue.");
                position = start_position;
                return dataItem;
            }

            MatchTerminal(':', out success);
            if (!success)
            {
                Error("Failed to parse ':' of BlockExplicitValue.");
                position = start_position;
                return dataItem;
            }

            dataItem = ParseBlockCollectionEntry(out success);
            if (!success)
            {
                Error("Failed to parse BlockCollectionEntry of BlockExplicitValue.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private DataItem ParseBlockSimpleKey(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = null;
            int start_position = position;

            dataItem = ParseBlockKey(out success);
            if (!success)
            {
                Error("Failed to parse BlockKey of BlockSimpleKey.");
                position = start_position;
                return dataItem;
            }

            ParseSeparationLines(out success);
            success = true;

            MatchTerminal(':', out success);
            if (!success)
            {
                Error("Failed to parse ':' of BlockSimpleKey.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return dataItem;
        }

        private DataItem ParseBlockSimpleValue(out bool success)
        {
            int errorCount = Errors.Count;
            DataItem dataItem = ParseBlockCollectionEntry(out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse BlockCollectionEntry of BlockSimpleValue."); }
            return dataItem;
        }

        private void ParseComment(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            int not_start_position1 = position;
            success = !Input.HasInput(position);
            position = not_start_position1;
            success = !success;
            if (!success)
            {
                Error("Failed to parse !(eof) of Comment.");
                position = start_position;
                return;
            }

            ParseIgnoredSpace(out success);

            while (true)
            {
                int seq_start_position2 = position;
                MatchTerminal('#', out success);
                if (!success)
                {
                    Error("Failed to parse '#' of Comment.");
                    break;
                }

                while (true)
                {
                    ParseNonBreakChar(out success);
                    if (!success) { break; }
                }
                success = true;
                break;
            }
            success = true;

            ErrorStatck.Push(errorCount); errorCount = Errors.Count;
            while (true)
            {
                ParseLineBreak(out success);
                if (success) { ClearError(errorCount); break; }

                success = !Input.HasInput(position);
                if (success) { ClearError(errorCount); break; }

                break;
            }
            errorCount = ErrorStatck.Pop();
            if (!success)
            {
                Error("Failed to parse (LineBreak / eof) of Comment.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
        }

        private void ParseInlineComment(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            while (true)
            {
                int seq_start_position1 = position;
                ParseSeparationSpace(out success);
                if (!success)
                {
                    Error("Failed to parse SeparationSpace of InlineComment.");
                    break;
                }

                while (true)
                {
                    int seq_start_position2 = position;
                    MatchTerminal('#', out success);
                    if (!success)
                    {
                        Error("Failed to parse '#' of InlineComment.");
                        break;
                    }

                    while (true)
                    {
                        ParseNonBreakChar(out success);
                        if (!success) { break; }
                    }
                    success = true;
                    break;
                }
                success = true;
                break;
            }
            success = true;

            ErrorStatck.Push(errorCount); errorCount = Errors.Count;
            while (true)
            {
                ParseLineBreak(out success);
                if (success) { ClearError(errorCount); break; }

                success = !Input.HasInput(position);
                if (success) { ClearError(errorCount); break; }

                break;
            }
            errorCount = ErrorStatck.Pop();
            if (!success)
            {
                Error("Failed to parse (LineBreak / eof) of InlineComment.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
        }

        private void ParseComments(out bool success)
        {
            int errorCount = Errors.Count;
            int counter = 0;
            while (true)
            {
                ParseComment(out success);
                if (!success) { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse (Comment)+ of Comments."); }
        }

        private void ParseInlineComments(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            ParseInlineComment(out success);
            if (!success)
            {
                Error("Failed to parse InlineComment of InlineComments.");
                position = start_position;
                return;
            }

            while (true)
            {
                ParseComment(out success);
                if (!success) { break; }
            }
            success = true;

        }

        private string ParseInteger(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            List<char> chars = new List<char>();
            int counter = 0;
            while (true)
            {
                char ch = ParseDigit(out success);
                if (success) { chars.Add(ch); }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); return new string(chars.ToArray()); }
            else { Error("Failed to parse chars of Integer."); }
            return text.ToString();
        }

        private char ParseWordChar(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            ch = ParseLetter(out success);
            if (success) { ClearError(errorCount); return ch; }

            ch = ParseDigit(out success);
            if (success) { ClearError(errorCount); return ch; }

            ch = MatchTerminal('-', out success);
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

        private char ParseLetter(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            ch = MatchTerminalRange('a', 'z', out success);
            if (success) { ClearError(errorCount); return ch; }

            ch = MatchTerminalRange('A', 'Z', out success);
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

        private char ParseDigit(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminalRange('0', '9', out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse '0'...'9' of Digit."); }
            return ch;
        }

        private char ParseHexDigit(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            ch = MatchTerminalRange('0', '9', out success);
            if (success) { ClearError(errorCount); return ch; }

            ch = MatchTerminalRange('A', 'F', out success);
            if (success) { ClearError(errorCount); return ch; }

            ch = MatchTerminalRange('a', 'f', out success);
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

        private char ParseUriChar(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            ch = ParseWordChar(out success);
            if (success) { ClearError(errorCount); return ch; }

            while (true)
            {
                int seq_start_position1 = position;
                MatchTerminal('%', out success);
                if (!success)
                {
                    Error("Failed to parse '%' of UriChar.");
                    break;
                }

                char char1 = ParseHexDigit(out success);
                if (!success)
                {
                    Error("Failed to parse char1 of UriChar.");
                    position = seq_start_position1;
                    break;
                }

                char char2 = ParseHexDigit(out success);
                if (success) { ch = Convert.ToChar(int.Parse(String.Format("{0}{1}", char1, char2), System.Globalization.NumberStyles.HexNumber)); }
                else
                {
                    Error("Failed to parse char2 of UriChar.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return ch; }

            MatchTerminalSet(";/?:@&=+$,_.!~*'()[]", false, out success);
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

        private char ParseTagChar(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            ch = ParseWordChar(out success);
            if (success) { ClearError(errorCount); return ch; }

            while (true)
            {
                int seq_start_position1 = position;
                MatchTerminal('%', out success);
                if (!success)
                {
                    Error("Failed to parse '%' of TagChar.");
                    break;
                }

                char char1 = ParseHexDigit(out success);
                if (!success)
                {
                    Error("Failed to parse char1 of TagChar.");
                    position = seq_start_position1;
                    break;
                }

                char char2 = ParseHexDigit(out success);
                if (success) { ch = Convert.ToChar(int.Parse(String.Format("{0}{1}", char1, char2), System.Globalization.NumberStyles.HexNumber)); }
                else
                {
                    Error("Failed to parse char2 of TagChar.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return ch; }

            MatchTerminalSet(";/?:@&=+$,_.~*'()[]", false, out success);
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

        private void ParseEmptyLinePlain(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            ParseIgnoredSpace(out success);

            ParseNormalizedLineBreak(out success);
            if (!success)
            {
                Error("Failed to parse NormalizedLineBreak of EmptyLinePlain.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
        }

        private void ParseEmptyLineQuoted(out bool success)
        {
            int errorCount = Errors.Count;
            int start_position = position;

            ParseIgnoredBlank(out success);

            ParseNormalizedLineBreak(out success);
            if (!success)
            {
                Error("Failed to parse NormalizedLineBreak of EmptyLineQuoted.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
        }

        private string ParseEmptyLineBlock(out bool success)
        {
            int errorCount = Errors.Count;
            string str = null;
            int start_position = position;

            ParseIgnoredSpace(out success);

            str = ParseReservedLineBreak(out success);
            if (!success)
            {
                Error("Failed to parse ReservedLineBreak of EmptyLineBlock.");
                position = start_position;
            }

            if (success) { ClearError(errorCount); }
            return str;
        }

        private char ParseNonSpaceChar(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminalSet(" \t\r\n", true, out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse -\" \t\r\n\" of NonSpaceChar."); }
            return ch;
        }

        private char ParseNonSpaceSep(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminalSet("\r\n\t ,[]{}", true, out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse -\"\r\n\t ,[]{}\" of NonSpaceSep."); }
            return ch;
        }

        private char ParseNonBreakChar(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminalSet("\r\n", true, out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse -\"\r\n\" of NonBreakChar."); }
            return ch;
        }

        private void ParseIgnoredSpace(out bool success)
        {
            int errorCount = Errors.Count;
            while (true)
            {
                MatchTerminal(' ', out success);
                if (!success) { break; }
            }
            success = true;
        }

        private void ParseIgnoredBlank(out bool success)
        {
            int errorCount = Errors.Count;
            while (true)
            {
                MatchTerminalSet(" \t", false, out success);
                if (!success) { break; }
            }
            success = true;
        }

        private void ParseSeparationSpace(out bool success)
        {
            int errorCount = Errors.Count;
            int counter = 0;
            while (true)
            {
                MatchTerminal(' ', out success);
                if (!success) { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse (' ')+ of SeparationSpace."); }
        }

        private void ParseSeparationLines(out bool success)
        {
            int errorCount = Errors.Count;
            while (true)
            {
                int seq_start_position1 = position;
                ParseInlineComments(out success);
                if (!success)
                {
                    Error("Failed to parse InlineComments of SeparationLines.");
                    break;
                }

                ParseIndent(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of SeparationLines.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return; }

            ParseSeparationSpace(out success);
            if (success) { ClearError(errorCount); return; }

        }

        private void ParseSeparationLinesInFlow(out bool success)
        {
            int errorCount = Errors.Count;
            while (true)
            {
                int seq_start_position1 = position;
                ParseInlineComments(out success);
                if (success) { detectIndent = false; }
                else
                {
                    Error("Failed to parse InlineComments of SeparationLinesInFlow.");
                    break;
                }

                ParseIndent(out success);
                if (!success)
                {
                    Error("Failed to parse Indent of SeparationLinesInFlow.");
                    position = seq_start_position1;
                    break;
                }

                ParseIgnoredSpace(out success);
                break;
            }
            if (success) { ClearError(errorCount); return; }

            ParseSeparationSpace(out success);
            if (success) { ClearError(errorCount); return; }

        }

        private void ParseSeparationSpaceAsIndent(out bool success)
        {
            int errorCount = Errors.Count;
            int counter = 0;
            while (true)
            {
                MatchTerminal(' ', out success);
                if (success) { currentIndent++; }
                else { break; }
                counter++;
            }
            if (counter > 0) { success = true; }
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse ((' '))+ of SeparationSpaceAsIndent."); }
        }

        private void ParseIndent(out bool success)
        {
            success = ParseIndent();
            int errorCount = Errors.Count;
        }

        private char ParseSpace(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminal(' ', out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse ' ' of Space."); }
            return ch;
        }

        private char ParseBlank(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = MatchTerminalSet(" \t", false, out success);
            if (success) { ClearError(errorCount); }
            else { Error("Failed to parse \" \t\" of Blank."); }
            return ch;
        }

        private void ParseLineBreak(out bool success)
        {
            int errorCount = Errors.Count;
            MatchTerminalString("\r\n", out success);
            if (success) { ClearError(errorCount); return; }

            MatchTerminal('\r', out success);
            if (success) { ClearError(errorCount); return; }

            MatchTerminal('\n', out success);
            if (success) { ClearError(errorCount); return; }

        }

        private string ParseReservedLineBreak(out bool success)
        {
            int errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            string str = MatchTerminalString("\r\n", out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(str);
                return text.ToString();
            }

            char ch = MatchTerminal('\r', out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(ch);
                return text.ToString();
            }

            ch = MatchTerminal('\n', out success);
            if (success)
            {
                ClearError(errorCount);
                text.Append(ch);
                return text.ToString();
            }

            return text.ToString();
        }

        private string ParseChompedLineBreak(out bool success)
        {
            int errorCount = Errors.Count;
            ErrorStatck.Push(errorCount); errorCount = Errors.Count;
            StringBuilder text = new StringBuilder();

            while (true)
            {
                while (true)
                {
                    int seq_start_position1 = position;
                    string str = ParseReservedLineBreak(out success);
                    if (success) { text.Append(str); }
                    else
                    {
                        Error("Failed to parse ReservedLineBreak of ChompedLineBreak.");
                        break;
                    }

                    while (true)
                    {
                        while (true)
                        {
                            int seq_start_position2 = position;
                            ParseIgnoredSpace(out success);

                            str = ParseReservedLineBreak(out success);
                            if (success) { text.Append(str); }
                            else
                            {
                                Error("Failed to parse ReservedLineBreak of ChompedLineBreak.");
                                position = seq_start_position2;
                            }
                            break;
                        }
                        if (!success) { break; }
                    }
                    success = true;
                    break;
                }
                if (success) { ClearError(errorCount); break; }

                success = !Input.HasInput(position);
                if (success) { ClearError(errorCount); break; }

                break;
            }
            errorCount = ErrorStatck.Pop();
            return Chomp(text.ToString());
        }

        private char ParseNormalizedLineBreak(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);
            ParseLineBreak(out success);
            if (success) { ClearError(errorCount); return '\n'; }
            else { Error("Failed to parse LineBreak of NormalizedLineBreak."); }
            return ch;
        }

        private char ParseEscapeSequence(out bool success)
        {
            int errorCount = Errors.Count;
            char ch = default(char);

            MatchTerminalString("\\\\", out success);
            if (success) { return '\\'; }

            MatchTerminalString("\\'", out success);
            if (success) { return '\''; }

            MatchTerminalString("\\\"", out success);
            if (success) { return '\"'; }

            MatchTerminalString("\\r", out success);
            if (success) { return '\r'; }

            MatchTerminalString("\\n", out success);
            if (success) { return '\n'; }

            MatchTerminalString("\\t", out success);
            if (success) { return '\t'; }

            MatchTerminalString("\\v", out success);
            if (success) { return '\v'; }

            MatchTerminalString("\\a", out success);
            if (success) { return '\a'; }

            MatchTerminalString("\\b", out success);
            if (success) { return '\b'; }

            MatchTerminalString("\\f", out success);
            if (success) { return '\f'; }

            MatchTerminalString("\\0", out success);
            if (success) { return '\0'; }

            MatchTerminalString("\\/", out success);
            if (success) { return '/'; }

            MatchTerminalString("\\ ", out success);
            if (success) { return ' '; }

            MatchTerminalString("\\\t", out success);
            if (success) { return '	'; }

            MatchTerminalString("\\_", out success);
            if (success) { return '\u00A0'; }

            MatchTerminalString("\\e", out success);
            if (success) { return '\u001B'; }

            MatchTerminalString("\\N", out success);
            if (success) { return '\u0085'; }

            MatchTerminalString("\\L", out success);
            if (success) { return '\u2028'; }

            MatchTerminalString("\\P", out success);
            if (success) { return '\u2029'; }

            while (true)
            {
                int seq_start_position1 = position;
                MatchTerminalString("\\x", out success);
                if (!success)
                {
                    Error("Failed to parse '\\\\x' of EscapeSequence.");
                    break;
                }

                char char1 = ParseHexDigit(out success);
                if (!success)
                {
                    Error("Failed to parse char1 of EscapeSequence.");
                    position = seq_start_position1;
                    break;
                }

                char char2 = ParseHexDigit(out success);
                if (success) { return Convert.ToChar(int.Parse(String.Format("{0}{1}", char1, char2), System.Globalization.NumberStyles.HexNumber)); }
                else
                {
                    Error("Failed to parse char2 of EscapeSequence.");
                    position = seq_start_position1;
                }
                break;
            }
            if (success) { ClearError(errorCount); return ch; }

            while (true)
            {
                int seq_start_position2 = position;
                MatchTerminalString("\\u", out success);
                if (!success)
                {
                    Error("Failed to parse '\\\\u' of EscapeSequence.");
                    break;
                }

                char char1 = ParseHexDigit(out success);
                if (!success)
                {
                    Error("Failed to parse char1 of EscapeSequence.");
                    position = seq_start_position2;
                    break;
                }

                char char2 = ParseHexDigit(out success);
                if (!success)
                {
                    Error("Failed to parse char2 of EscapeSequence.");
                    position = seq_start_position2;
                    break;
                }

                char char3 = ParseHexDigit(out success);
                if (!success)
                {
                    Error("Failed to parse char3 of EscapeSequence.");
                    position = seq_start_position2;
                    break;
                }

                char char4 = ParseHexDigit(out success);
                if (success) { return Convert.ToChar(int.Parse(String.Format("{0}{1}{2}{3}", char1, char2, char3, char4), System.Globalization.NumberStyles.HexNumber)); }
                else
                {
                    Error("Failed to parse char4 of EscapeSequence.");
                    position = seq_start_position2;
                }
                break;
            }
            if (success) { ClearError(errorCount); return ch; }

            return ch;
        }

    }
}
